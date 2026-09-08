class Classlist < ApplicationRecord
  belongs_to :section, counter_cache: :student_count
  belongs_to :student

  after_create :student_enrolled
  after_destroy :student_dropped
  after_update :enrollment_was_edited

  private
    def subject
      section.subject
    end

    def student_enrolled
      add_subject_to(student, subject)
    end

    def student_dropped
      remove_subject_from(student, subject)
    end

    def enrollment_was_edited
      return unless saved_change_to_section_id? || saved_change_to_student_id?
      old_student = Student.find_by(id: student_id_before_last_save)
      old_section = Section.find_by(id: section_id_before_last_save)
      remove_subject_from(old_student, old_section.subject) if old_student && old_section
      add_subject_to(student, subject)
    end

    def add_subject_to(a_student, a_subject)
      a_student.reload
      a_student.subjects_count += 1
      a_student.number_of_units += a_subject.number_of_units
      a_student.tuition_fee += a_subject.number_of_units * a_subject.per_unit_rate
      a_student.save!
    end

    def remove_subject_from(a_student, a_subject)
      a_student.reload
      a_student.subjects_count -= 1
      a_student.number_of_units -= a_subject.number_of_units
      a_student.tuition_fee -= a_subject.number_of_units * a_subject.per_unit_rate
      a_student.save!
    end
end