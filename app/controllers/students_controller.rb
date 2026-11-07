class StudentsController < ApplicationController
  before_action :set_student, only: %i[show edit update destroy]

  add_breadcrumb "Home", :root_path
  add_breadcrumb "Students", :students_path

  # GET /students or /students.json
  def index
    @q = Student.ransack(params[:q])

    @pagy, @students = pagy(
      :offset,
      @q.result(distinct: true)
        .includes(:department, :sections)
        .order(:name),
      limit: 10
    )
  end

  # GET /students/1 or /students/1.json
  def show
    add_breadcrumb @student.name, student_path(@student)

    @classlist = Classlist.new(student: @student)

    @available_sections = Section
      .where.not(id: @student.section_ids)
      .order(:name)
  end

  # GET /students/search?q=jo
  def search
    return render(json: []) if params[:q].blank?

    students = Student
      .ransack(name_cont: params[:q])
      .result
      .order(:name)
      .limit(8)

    render json: students.map { |s|
      {
        name: s.name,
        subtitle: "#{s.program} · Year #{s.year_level}",
        url: student_path(s)
      }
    }
  end

  # GET /students/new
  def new
    @student = Student.new
  end

  # GET /students/1/edit
  def edit
  end

  # POST /students or /students.json
  def create
    @student = Student.new(student_params)

    respond_to do |format|
      if @student.save
        format.html do
          redirect_to @student,
                      notice: "Student was successfully created."
        end

        format.json do
          render :show,
                 status: :created,
                 location: @student
        end
      else
        format.html do
          render :new,
                 status: :unprocessable_content
        end

        format.json do
          render json: @student.errors,
                 status: :unprocessable_content
        end
      end
    end
  end

  # PATCH/PUT /students/1 or /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html do
          redirect_to @student,
                      notice: "Student was successfully updated.",
                      status: :see_other
        end

        format.json do
          render :show,
                 status: :ok,
                 location: @student
        end
      else
        format.html do
          render :edit,
                 status: :unprocessable_content
        end

        format.json do
          render json: @student.errors,
                 status: :unprocessable_content
        end
      end
    end
  end

  # DELETE /students/1 or /students/1.json
  def destroy
    @student.destroy!

    respond_to do |format|
      format.html do
        redirect_to students_path,
                    notice: "Student was successfully destroyed.",
                    status: :see_other
      end

      format.json do
        head :no_content
      end
    end
  end

  private

  # Load the student for show, edit, update, and destroy.
  def set_student
    @student = Student.find(params.expect(:id))
  end

  # Only allow trusted parameters.
  def student_params
    params.expect(
      student: [
        :name,
        :year_level,
        :program,
        :department_id
      ]
    )
  end
end