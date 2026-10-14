class HomeController < ApplicationController
  def index
    @department_count = Department.count
    @teacher_count    = Teacher.count
    @student_count    = Student.count
    @subject_count    = Subject.count
    @section_count    = Section.count
    @class_list_count = Classlist.count
    @teachers = Teacher.order(:name).limit(3)
  end
end