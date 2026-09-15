class BackfillDepartmentCounterCaches < ActiveRecord::Migration[8.1]
  def up
    Department.find_each do |department|
      Department.reset_counters(
        department.id,
        :students,
        :teachers,
        :laboratories
      )
    end
  end

  def down
    Department.update_all(
      students_count: nil,
      teachers_count: nil,
      laboratories_count: nil
    )
  end
end