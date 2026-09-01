class CreateClasslists < ActiveRecord::Migration[8.1]
  def change
    create_table :classlists do |t|
      t.references :subject, null: false, foreign_key: true
      t.references :student, null: false, foreign_key: true

      t.timestamps
    end
  end
end
