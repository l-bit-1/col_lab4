class ClasslistsController < ApplicationController
  before_action :set_classlist, only: %i[ show edit update destroy ]

  # GET /classlists or /classlists.json
  def index
    @classlists = Classlist.joins(:section).order("sections.name")
  end

  # GET /classlists/1 or /classlists/1.json
  def show
  end

  # GET /classlists/new
  def new
    @classlist = Classlist.new
  end

  # GET /classlists/1/edit
  def edit
  end

  # POST /classlists or /classlists.json
  def create
    @classlist = Classlist.new(classlist_params)
    student = Student.find_by(id: params[:from_student])

    respond_to do |format|
      if @classlist.save
        format.html { redirect_to student || @classlist, notice: "Classlist was successfully created." }
        format.json { render :show, status: :created, location: @classlist }
      else
        format.html do
          if student
            redirect_to student, alert: @classlist.errors.full_messages.to_sentence, status: :see_other
          else
            render :new, status: :unprocessable_content
          end
        end
        format.json { render json: @classlist.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /classlists/1 or /classlists/1.json
  def update
    respond_to do |format|
      if @classlist.update(classlist_params)
        format.html { redirect_to @classlist, notice: "Classlist was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @classlist }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @classlist.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /classlists/1 or /classlists/1.json
  def destroy
    student = Student.find_by(id: params[:from_student])

    @classlist.destroy!

    respond_to do |format|
      format.html { redirect_to student || classlists_path, notice: "Classlist was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_classlist
      @classlist = Classlist.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def classlist_params
      params.expect(classlist: [ :section_id, :student_id ])
    end
end
