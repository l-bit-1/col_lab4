class AddStudentColumns < ActiveRecord::Migration[8.1]
  def change
    add_column :students, :tuition_fee, :double, default: 0.0
    add_column :students, :subjects_count, :integer, default: 0
    add_column :students, :number_of_units, :integer, default: 0
  end
end
