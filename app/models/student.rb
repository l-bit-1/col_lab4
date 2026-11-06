class Student < ApplicationRecord
  belongs_to :department, counter_cache: :students_count
  has_many :classlists, dependent: :destroy
  has_many :sections, through: :classlists, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    %w[name year_level program]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[section]
  end
end
