class ApplicationController < ActionController::API
  before_action :authenticate_user!
  def authenticate_user!
    token = request.headers['Authorization']&.split(' ')&.last
    if token.present?
      begin
        decoded_token = JWT.decode(token, Rails.application.credentials.secret_key_base, true, algorithm: 'HS256')
        @current_user = User.find(decoded_token[0]['user_id'])
      rescue JWT::DecodeError
        render json: { error: 'Invalid token' }, status: :unauthorized
      end
    else
      render json: { error: 'Authorization token required' }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end
end
