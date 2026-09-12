# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_09_11_235518) do
  create_table "classlists", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "section_id", null: false
    t.bigint "student_id", null: false
    t.datetime "updated_at", null: false
    t.index ["section_id"], name: "index_classlists_on_section_id"
    t.index ["student_id"], name: "index_classlists_on_student_id"
  end

  create_table "departments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "location"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "laboratories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "department_id", null: false
    t.string "location"
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_laboratories_on_department_id"
  end

  create_table "sections", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.string "room"
    t.integer "student_count", default: 0
    t.bigint "subject_id", null: false
    t.string "timeslot"
    t.datetime "updated_at", null: false
    t.index ["subject_id"], name: "index_sections_on_subject_id"
  end

  create_table "students", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "department_id", null: false
    t.string "name"
    t.integer "number_of_units", default: 0
    t.string "program"
    t.integer "subjects_count", default: 0
    t.float "tuition_fee", limit: 53, default: 0.0
    t.datetime "updated_at", null: false
    t.integer "year_level"
    t.index ["department_id"], name: "index_students_on_department_id"
  end

  create_table "subjects", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.integer "number_of_units", default: 3
    t.float "per_unit_rate", limit: 53, default: 1000.0
    t.integer "section_count", default: 0
    t.bigint "teacher_id", null: false
    t.datetime "updated_at", null: false
    t.index ["teacher_id"], name: "index_subjects_on_teacher_id"
  end

  create_table "teachers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "department_id", null: false
    t.string "email"
    t.float "monthly_salary", default: 0.0
    t.string "name"
    t.float "per_unit_rate", default: 0.0
    t.string "specialization"
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_teachers_on_department_id"
  end

  add_foreign_key "classlists", "sections"
  add_foreign_key "classlists", "students"
  add_foreign_key "laboratories", "departments"
  add_foreign_key "sections", "subjects"
  add_foreign_key "students", "departments"
  add_foreign_key "subjects", "teachers"
  add_foreign_key "teachers", "departments"
end
