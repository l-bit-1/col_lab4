class Teacher < ApplicationRecord
  belongs_to :department, counter_cache: :teachers_count
  has_many :subjects, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    %w[name]
  end

  def monthly_salary
    subjects.sum(:number_of_units) * (per_unit_rate || 0)
  end
end
