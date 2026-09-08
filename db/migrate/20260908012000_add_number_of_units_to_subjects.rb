class AddNumberOfUnitsToSubjects < ActiveRecord::Migration[8.1]
  def change
    add_column :subjects, :number_of_units, :integer, default: 3
  end
end
