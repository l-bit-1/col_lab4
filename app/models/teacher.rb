class Teacher < ApplicationRecord

  belongs_to :department

  has_many :subjects, dependent: :destroy

  def monthly_salary
    subjects.sum(:number_of_units) * per_unit_rate
  end

end