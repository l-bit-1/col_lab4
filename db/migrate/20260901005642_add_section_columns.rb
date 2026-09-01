class AddSectionColumns < ActiveRecord::Migration[8.1]
  def change
    add_column :sections, :name, :string
    add_column :sections, :room, :string
    add_column :sections, :timeslot, :string
    add_reference :sections, :subject, null: false, foreign_key: true
  end
end
