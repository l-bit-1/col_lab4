class TeachersController < ApplicationController
  before_action :set_teacher, only: %i[show edit update destroy]

  add_breadcrumb "Home", :root_path
  add_breadcrumb "Teachers", :teachers_path

  # GET /teachers or /teachers.json
  def index
    @teachers = Teacher.all
  end

  # GET /teachers/search?q=ep
  def search
    return render(json: []) if params[:q].blank?

    teachers = Teacher
      .ransack(name_cont: params[:q])
      .result
      .includes(:department)
      .order(:name)
      .limit(8)

    render json: teachers.map { |t|
      {
        name: t.name,
        subtitle: t.department&.name,
        url: teacher_path(t)
      }
    }
  end

  # GET /teachers/1 or /teachers/1.json
  def show
    add_breadcrumb @teacher.name, teacher_path(@teacher)
  end

  # GET /teachers/new
  def new
    @teacher = Teacher.new
  end

  # GET /teachers/1/edit
  def edit
  end

  # POST /teachers or /teachers.json
  def create
    @teacher = Teacher.new(teacher_params)

    respond_to do |format|
      if @teacher.save
        format.html do
          redirect_to @teacher,
                      notice: "Teacher was successfully created."
        end

        format.json do
          render :show,
                 status: :created,
                 location: @teacher
        end
      else
        format.html do
          render :new,
                 status: :unprocessable_content
        end

        format.json do
          render json: @teacher.errors,
                 status: :unprocessable_content
        end
      end
    end
  end

  # PATCH/PUT /teachers/1 or /teachers/1.json
  def update
    respond_to do |format|
      if @teacher.update(teacher_params)
        format.html do
          redirect_to @teacher,
                      notice: "Teacher was successfully updated.",
                      status: :see_other
        end

        format.json do
          render :show,
                 status: :ok,
                 location: @teacher
        end
      else
        format.html do
          render :edit,
                 status: :unprocessable_content
        end

        format.json do
          render json: @teacher.errors,
                 status: :unprocessable_content
        end
      end
    end
  end

  # DELETE /teachers/1 or /teachers/1.json
  def destroy
    @teacher.destroy!

    respond_to do |format|
      format.html do
        redirect_to teachers_path,
                    notice: "Teacher was successfully destroyed.",
                    status: :see_other
      end

      format.json do
        head :no_content
      end
    end
  end

  private

  # Load the teacher for show, edit, update, and destroy.
  def set_teacher
    @teacher = Teacher.find(params.expect(:id))
  end

  # Only allow trusted parameters.
  def teacher_params
    params.expect(
      teacher: [
        :name,
        :email,
        :specialization,
        :department_id,
        :per_unit_rate
      ]
    )
  end
end