# Order matters: each group needs the one above it to exist first.
# departments -> teachers -> subjects -> sections -> students -> classlists

# 1. Departments
cpe = Department.find_or_create_by!(name: "Computer Engineering") do |d|
  d.location = "Engineering Building"
end

cs = Department.find_or_create_by!(name: "Computer Science") do |d|
  d.location = "Science Building"
end

# 2. Teachers (need a department)
ada = Teacher.find_or_create_by!(email: "ada.lovelace@example.com") do |t|
  t.name = "Ada Lovelace"
  t.specialization = "Algorithms"
  t.per_unit_rate = 1000
  t.department = cpe
end

alan = Teacher.find_or_create_by!(email: "alan.turing@example.com") do |t|
  t.name = "Alan Turing"
  t.specialization = "Theory of Computation"
  t.per_unit_rate = 1000
  t.department = cs
end

# 3. Subjects (need a teacher)
algo = Subject.find_or_create_by!(name: "Data Structures and Algorithms") do |s|
  s.teacher = ada
end

theory = Subject.find_or_create_by!(name: "Automata Theory") do |s|
  s.teacher = alan
end

# 4. Sections (need a subject)
sec_a = Section.find_or_create_by!(name: "DSA-A") do |s|
  s.room = "Room 101"
  s.timeslot = "MWF 9:00-10:00"
  s.subject = algo
end

sec_b = Section.find_or_create_by!(name: "AT-A") do |s|
  s.room = "Room 202"
  s.timeslot = "TTh 1:00-2:30"
  s.subject = theory
end

# 5. Students (need a department)
student_data = [
  ["Maria Santos",  1, "BS Computer Engineering", cpe],
  ["Juan Dela Cruz", 2, "BS Computer Engineering", cpe],
  ["Ana Reyes",     3, "BS Computer Science",     cs],
  ["Luis Garcia",   4, "BS Computer Science",     cs]
]

students = student_data.map do |name, year, program, dept|
  Student.find_or_create_by!(name: name) do |s|
    s.year_level = year
    s.program = program
    s.department = dept
  end
end

# 6. Classlists (need a student and a section)
students.each do |student|
  [sec_a, sec_b].each do |section|
    Classlist.find_or_create_by!(student: student, section: section)
  end
end