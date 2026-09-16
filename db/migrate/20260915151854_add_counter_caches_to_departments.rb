class AddCounterCachesToDepartments < ActiveRecord::Migration[8.1]
  def change
    add_column :departments, :students_count, :integer
    add_column :departments, :teachers_count, :integer
    add_column :departments, :laboratories_count, :integer
  end
end
