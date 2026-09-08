class AddSubjectsColumn < ActiveRecord::Migration[8.1]
  def change
    add_column :subjects, :section_count, :integer, default: 0
  end
end
