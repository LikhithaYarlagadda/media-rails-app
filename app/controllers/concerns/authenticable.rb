module Authenticable
    # This method will be used to authenticate the user by decoding the JWT token
    def current_user
      @current_user ||= decode_token
    end
  
    # Method to decode the JWT token
    def decode_token
      header = request.headers['Authorization']&.split(' ')
  
      if header && header[0] == 'Bearer' && header[1]
        token = header[1]
        begin
            decoded_token = JWT.decode(token, Rails.application.credentials.secret_key_base, true, algorithm: 'HS256')
          user_id = decoded[0]['user_id']
          User.find_by(id: user_id)
        rescue JWT::DecodeError
          nil
        end
      end
    end
  
    # Check if the user is authenticated
    def authenticate_user!
      render json: { error: 'Unauthorized' }, status: :unauthorized unless current_user
    end

    def authenticate_editor_or_reporter!
        render json: { error: 'Forbidden' }, status: :forbidden unless current_user&.editor? || current_user&.reporter?
    end

  end
  