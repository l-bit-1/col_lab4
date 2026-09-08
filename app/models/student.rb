class Student < ApplicationRecord
  belongs_to :subject
  has_many :classlists
  has_many :students, through: :classlists, dependent: :destroy
end
