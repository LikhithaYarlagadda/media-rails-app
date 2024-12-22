# app/controllers/auth_controller.rb
class AuthController < ApplicationController
    skip_before_action :authenticate_user!, only: [:login]
    # POST /login
    def login
      # Find the user by email
      @user = User.find_by(email: params[:email])
  
      # Check if the user exists and if the password is correct
      if @user&.authenticate(params[:password])
        # Generate JWT token if authentication is successful
        token = generate_jwt_token(@user)
        render json: { token: token, user: @user }, status: :ok
      else
        render json: { error: 'Invalid email or password' }, status: :unauthorized
      end
    end
  
    private
  
    def generate_jwt_token(user)
      # JWT token expiration time
      exp = 24.hours.from_now.to_i
  
      # JWT payload with user ID and expiration time
      payload = { user_id: user.id, exp: exp }
  
      # Encode the payload with the secret key
      JWT.encode(payload, Rails.application.credentials.secret_key_base)
    end
  end
  