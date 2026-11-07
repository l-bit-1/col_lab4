class AddPerUnitRateToTeachers < ActiveRecord::Migration[8.1]
  def change
    add_column :teachers, :per_unit_rate, :decimal unless column_exists?(:teachers, :per_unit_rate)
  end
end
