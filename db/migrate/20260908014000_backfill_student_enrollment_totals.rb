class BackfillStudentEnrollmentTotals < ActiveRecord::Migration[8.1]
  def up
    Student.find_each do |student|
      subjects_count = 0
      number_of_units = 0
      tuition_fee = 0.0

      student.classlists.each do |classlist|
        subject = classlist.section.subject

        subjects_count += 1
        number_of_units += subject.number_of_units
        tuition_fee += subject.number_of_units * subject.per_unit_rate
      end

      student.update_columns(
        subjects_count: subjects_count,
        number_of_units: number_of_units,
        tuition_fee: tuition_fee
      )
    end
  end

  def down
  end
end
