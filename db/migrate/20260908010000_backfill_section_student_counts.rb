class BackfillSectionStudentCounts < ActiveRecord::Migration[8.1]
  def up
    Section.find_each { |section| Section.reset_counters(section.id, :classlists) }
  end

  def down
  end
end
