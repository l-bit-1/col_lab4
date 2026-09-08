class CreateLaboratories < ActiveRecord::Migration[8.1]
  def change
    create_table :laboratories do |t|
      t.string :name
      t.string :location
      t.references :department, null: false, foreign_key: true

      t.timestamps
    end
  end
end
