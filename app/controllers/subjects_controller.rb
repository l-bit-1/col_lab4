class SubjectsController < ApplicationController
  before_action :set_subject, only: %i[show edit update destroy]

  add_breadcrumb "Home", :root_path
  add_breadcrumb "Subjects", :subjects_path

  # GET /subjects or /subjects.json
  def index
    @subjects = Subject.all
  end

  # GET /subjects/1 or /subjects/1.json
  def show
    add_breadcrumb @subject.name, subject_path(@subject)
  end

  # GET /subjects/new
  def new
    @subject = Subject.new
  end

  # GET /subjects/1/edit
  def edit
  end

  # POST /subjects or /subjects.json
  def create
    @subject = Subject.new(subject_params)

    respond_to do |format|
      if @subject.save
        format.html do
          redirect_to @subject,
                      notice: "Subject was successfully created."
        end

        format.json do
          render :show,
                 status: :created,
                 location: @subject
        end
      else
        format.html do
          render :new,
                 status: :unprocessable_content
        end

        format.json do
          render json: @subject.errors,
                 status: :unprocessable_content
        end
      end
    end
  end

  # PATCH/PUT /subjects/1 or /subjects/1.json
  def update
    respond_to do |format|
      if @subject.update(subject_params)
        format.html do
          redirect_to @subject,
                      notice: "Subject was successfully updated.",
                      status: :see_other
        end

        format.json do
          render :show,
                 status: :ok,
                 location: @subject
        end
      else
        format.html do
          render :edit,
                 status: :unprocessable_content
        end

        format.json do
          render json: @subject.errors,
                 status: :unprocessable_content
        end
      end
    end
  end

  # DELETE /subjects/1 or /subjects/1.json
  def destroy
    @subject.destroy!

    respond_to do |format|
      format.html do
        redirect_to subjects_path,
                    notice: "Subject was successfully destroyed.",
                    status: :see_other
      end

      format.json do
        head :no_content
      end
    end
  end

  private

  # Load the subject for show, edit, update, and destroy.
  def set_subject
    @subject = Subject.find(params.expect(:id))
  end

  # Only allow trusted parameters.
  def subject_params
    params.expect(
      subject: [
        :name,
        :teacher_id
      ]
    )
  end
end