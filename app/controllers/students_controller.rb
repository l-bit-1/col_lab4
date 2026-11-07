class StudentsController < ApplicationController
  before_action :set_student, only: %i[ show edit update destroy ]

# GET /students or /students.json
def index
  @q = Student.ransack(params[:q])
  @pagy, @students = pagy(
    :offset,
    @q.result(distinct: true).includes(:department, :sections).order(:name),
    limit: 10
  )
end

# GET /students/search?q=jo
def search
  q = params[:q].to_s.strip
  return render(json: []) if q.blank?

  starts   = Student.ransack(name_start: q).result.order(:name).limit(5).to_a
  contains = Student.ransack(name_cont: q).result
                    .where.not(id: starts.map(&:id))
                    .order(:name).limit(5).to_a

  render json: starts.map   { |s| student_item(s, "starts") } +
               contains.map { |s| student_item(s, "contains") }
end

  # GET /students/1 or /students/1.json
  def show
    @classlist = Classlist.new(student: @student)
    @available_sections = Section.where.not(id: @student.section_ids).order(:name)
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
        format.html { redirect_to @student, notice: "Student was successfully created." }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @student.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /students/1 or /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to @student, notice: "Student was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @student.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /students/1 or /students/1.json
  def destroy
    @student.destroy!

    respond_to do |format|
      format.html { redirect_to students_path, notice: "Student was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params.expect(:id))
    end

    def student_item(student, group)
  {
    name: student.name,
    subtitle: "#{student.program} · Year #{student.year_level}",
    url: student_path(student),
    group: group
  }
end

    # Only allow a list of trusted parameters through.
    def student_params
      params.expect(student: [ :name, :year_level, :program, :department_id ])
    end
end
