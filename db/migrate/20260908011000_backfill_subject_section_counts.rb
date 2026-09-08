class BackfillSubjectSectionCounts < ActiveRecord::Migration[8.1]
  def up
    Subject.find_each { |subject| Subject.reset_counters(subject.id, :sections) }
  end

  def down
  end
end
