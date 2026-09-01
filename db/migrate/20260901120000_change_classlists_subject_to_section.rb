class ChangeClasslistsSubjectToSection < ActiveRecord::Migration[8.1]
  def up
    add_reference :classlists, :section, null: true, foreign_key: true

    # Backfill: point each enrollment at a section of the subject it referenced.
    execute <<~SQL
      UPDATE classlists c
      JOIN sections s ON s.subject_id = c.subject_id
      SET c.section_id = s.id
      WHERE c.section_id IS NULL
    SQL

    # Subjects with no section yet get one so no enrollment is left dangling.
    execute <<~SQL
      INSERT INTO sections (subject_id, name, created_at, updated_at)
      SELECT DISTINCT c.subject_id, 'Section 1', NOW(), NOW()
      FROM classlists c
      WHERE c.section_id IS NULL
    SQL

    execute <<~SQL
      UPDATE classlists c
      JOIN sections s ON s.subject_id = c.subject_id
      SET c.section_id = s.id
      WHERE c.section_id IS NULL
    SQL

    change_column_null :classlists, :section_id, false
    remove_reference :classlists, :subject, foreign_key: true
  end

  def down
    add_reference :classlists, :subject, null: true, foreign_key: true

    execute <<~SQL
      UPDATE classlists c
      JOIN sections s ON s.id = c.section_id
      SET c.subject_id = s.subject_id
    SQL

    change_column_null :classlists, :subject_id, false
    remove_reference :classlists, :section, foreign_key: true
  end
end
