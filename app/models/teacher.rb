class Teacher < ApplicationRecord
  belongs_to :department, counter_cache: :teachers_count
  has_many :subjects, dependent: :destroy
end