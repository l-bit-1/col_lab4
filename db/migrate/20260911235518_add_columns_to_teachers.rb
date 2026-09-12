class AddColumnsToTeachers < ActiveRecord::Migration[8.1]
  def change
    add_column :teachers, :monthly_salary, :float, default: 0.0
    add_column :teachers, :per_unit_rate, :float, default: 0.0
  end
end
