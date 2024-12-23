class UsersController < ApplicationController
  # Ensure the user is authenticated before updating their profile
  before_action :authenticate_user!, only: [:update]
  # Ensure users can only update their own profile
  before_action :authorize_user!, only: [:update]
  before_action :authenticate_editor!, only: [:change_role]

  # GET /users
  def index
    @users = User.all
    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    user_params = params.permit(:username, :email, :password, :role)
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    head :no_content
  end

  def change_role
    user = User.find_by(username: params[:username], email: params[:email])
    
    if user && user.role == "reporter"
      if user.update_columns(role: "editor")  # This skips validations
        render json: { message: 'Role changed to editor' }, status: :ok
      else
        render json: { error: 'Unable to change role' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'User not found or invalid role' }, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User not found" }, status: :not_found
  end
  
  def authorize_user!
    render json: { error: 'Forbidden' }, status: :forbidden unless current_user.id == params[:id].to_i
  end

  def authenticate_editor!
    authenticate_user!
    unless current_user.editor?
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end