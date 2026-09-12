class Subject < ApplicationRecord
  belongs_to :teacher
  has_many :sections, dependent: :destroy

  after_create :teacher_assigned
  after_destroy :teacher_unassigned
  after_update :teacher_assignment_was_edited

  private

  def teacher_assigned
    add_salary_to(teacher)
  end

  def teacher_unassigned
    remove_salary_from(teacher)
  end

  def teacher_assignment_was_edited
    old_teacher = Teacher.find_by(id: teacher_id_before_last_save)
    remove_salary_from(old_teacher) if old_teacher
    add_salary_to(teacher) if teacher
  end

  def add_salary_to(a_teacher)
      a_teacher.reload
      a_teacher.monthly_salary += number_of_units * a_teacher.per_unit_rate
      a_teacher.save!
  end

  def remove_salary_from(a_teacher)
  a_teacher.reload
  a_teacher.monthly_salary -= number_of_units * a_teacher.per_unit_rate
  a_teacher.save!
  end
end
