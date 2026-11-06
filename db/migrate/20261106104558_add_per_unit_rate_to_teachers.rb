class AddPerUnitRateToTeachers < ActiveRecord::Migration[8.1]
  def change
    add_column :teachers, :per_unit_rate, :decimal
  end
end
