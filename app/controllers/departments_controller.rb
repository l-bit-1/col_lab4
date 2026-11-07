class DepartmentsController < ApplicationController
  before_action :set_department, only: %i[show edit update destroy]

  add_breadcrumb "Home", :root_path
  add_breadcrumb "Departments", :departments_path

  # GET /departments or /departments.json
  def index
    @departments = Department.all
  end

  # GET /departments/1 or /departments/1.json
  def show
    add_breadcrumb @department.name, department_path(@department)
  end

  # GET /departments/new
  def new
    @department = Department.new
  end

  # GET /departments/1/edit
  def edit
  end

  # POST /departments or /departments.json
  def create
    @department = Department.new(department_params)

    respond_to do |format|
      if @department.save
        format.html { redirect_to @department, notice: "Department was successfully created." }
        format.json { render :show, status: :created, location: @department }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @department.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /departments/1 or /departments/1.json
  def update
    respond_to do |format|
      if @department.update(department_params)
        format.html { redirect_to @department, notice: "Department was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @department }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @department.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /departments/1 or /departments/1.json
  def destroy
    @department.destroy!

    respond_to do |format|
      format.html { redirect_to departments_path, notice: "Department was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  def set_department
    @department = Department.find(params.expect(:id))
  end

  def department_params
    params.expect(department: [:name, :location])
  end
end