class LaboratoriesController < ApplicationController
  before_action :set_laboratory, only: %i[ show edit update destroy ]

  # GET /laboratories or /laboratories.json
  def index
    @laboratories = Laboratory.all
  end

  # GET /laboratories/1 or /laboratories/1.json
  def show
  end

  # GET /laboratories/new
  def new
    @laboratory = Laboratory.new
  end

  # GET /laboratories/1/edit
  def edit
  end

  # POST /laboratories or /laboratories.json
  def create
    @laboratory = Laboratory.new(laboratory_params)

    respond_to do |format|
      if @laboratory.save
        format.html { redirect_to @laboratory, notice: "Laboratory was successfully created." }
        format.json { render :show, status: :created, location: @laboratory }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @laboratory.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /laboratories/1 or /laboratories/1.json
  def update
    respond_to do |format|
      if @laboratory.update(laboratory_params)
        format.html { redirect_to @laboratory, notice: "Laboratory was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @laboratory }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @laboratory.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /laboratories/1 or /laboratories/1.json
  def destroy
    @laboratory.destroy!

    respond_to do |format|
      format.html { redirect_to laboratories_path, notice: "Laboratory was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_laboratory
      @laboratory = Laboratory.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def laboratory_params
      params.expect(laboratory: [ :name, :location, :department_id ])
    end
end
