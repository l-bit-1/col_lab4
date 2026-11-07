class SectionsController < ApplicationController
  before_action :set_section, only: %i[show edit update destroy]

  add_breadcrumb "Home", :root_path
  add_breadcrumb "Sections", :sections_path

  # GET /sections or /sections.json
  def index
    @sections = Section.all
  end

  # GET /sections/1 or /sections/1.json
  def show
    add_breadcrumb @section.name, section_path(@section)
  end

  # GET /sections/new
  def new
    @section = Section.new
  end

  # GET /sections/1/edit
  def edit
  end

  # POST /sections or /sections.json
  def create
    @section = Section.new(section_params)

    respond_to do |format|
      if @section.save
        format.html do
          redirect_to @section,
                      notice: "Section was successfully created."
        end

        format.json do
          render :show,
                 status: :created,
                 location: @section
        end
      else
        format.html do
          render :new,
                 status: :unprocessable_content
        end

        format.json do
          render json: @section.errors,
                 status: :unprocessable_content
        end
      end
    end
  end

  # PATCH/PUT /sections/1 or /sections/1.json
  def update
    respond_to do |format|
      if @section.update(section_params)
        format.html do
          redirect_to @section,
                      notice: "Section was successfully updated.",
                      status: :see_other
        end

        format.json do
          render :show,
                 status: :ok,
                 location: @section
        end
      else
        format.html do
          render :edit,
                 status: :unprocessable_content
        end

        format.json do
          render json: @section.errors,
                 status: :unprocessable_content
        end
      end
    end
  end

  # DELETE /sections/1 or /sections/1.json
  def destroy
    @section.destroy!

    respond_to do |format|
      format.html do
        redirect_to sections_path,
                    notice: "Section was successfully destroyed.",
                    status: :see_other
      end

      format.json do
        head :no_content
      end
    end
  end

  private

  # Load the section for show, edit, update, and destroy.
  def set_section
    @section = Section.find(params.expect(:id))
  end

  # Only allow trusted parameters.
  def section_params
    params.expect(
      section: [
        :name,
        :room,
        :timeslot,
        :subject_id
      ]
    )
  end
end