class SectionsController < ApplicationController
  # Only Editors can create, update, or destroy sections
  before_action :authenticate_editor!, only: [:show, :create, :update, :destroy]
  # Allow only Editors and Reporters to view sections
  before_action :authenticate_editor_or_reporter!, only: [:index, :show]

  # GET /sections
  def index
    if current_user.editor? || current_user.reporter?
      @sections = Section.all
      render json: @sections
    else
      render json: { error: 'Unauthorized' }, status: :forbidden
    end
  end

  def show
    @section = Section.find(params[:id])
    render json: @section
  end

  # POST /sections
  def create
    @section = Section.new(section_params)
    if @section.save
      render json: @section, status: :created
    else
      render json: @section.errors, status: :unprocessable_entity
    end
  end

  # PUT /sections/:id
  def update
    @section = Section.find_by(id: params[:id])
    if @section.update(section_params)
      render json: @section, status: :ok
    else
      render json: { errors: @section.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /sections/:id
  def destroy
    @section = Section.find_by(id: params[:id])
    if @section.nil?
      render json: { error: "Section not found" }, status: :not_found
      return
    end
    if @section.destroy
      render json: { message: "Section deleted successfully" }, status: :ok
    else
      render json: { error: "Failed to delete section" }, status: :unprocessable_entity
    end
  end

  private

  def section_params
    params.require(:section).permit(:name, :dimensions)
  end

  def set_section
    @section = Section.find(params[:id])
  end

  def authorize_editor
    unless current_user.editor?
      render json: { error: 'Unauthorized' }, status: :forbidden
    end
  end

  def authenticate_editor!
    render json: { error: 'Forbidden' }, status: :forbidden unless current_user.editor?
  end

  def authenticate_editor_or_reporter!
    render json: { error: 'Forbidden' }, status: :forbidden unless current_user.editor? || current_user.reporter?
  end
end