class Section < ApplicationRecord
  belongs_to :subject, counter_cache: :section_count
  has_many :classlists, dependent: :destroy
  has_many :students, through: :classlists

  def display_name
    [ subject&.name, name ].compact_blank.join(" - ")
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[room timeslot]
  end
end
