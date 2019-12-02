# frozen_string_literal: true

module Partner
  class BaseController < ApiController
    before_action :set_app_locale
    attr_reader :current_user

    protected

    def set_app_locale
      I18n.default_locale = :ko
    end

    def authenticate_request!
      return render json: { errors: ['Not Authenticated'] }, status: :unauthorized unless user_id_in_token?

      @current_user = User.find(user_id_in_token)
    rescue JWT::VerificationError, JWT::DecodeError
      render json: { errors: ['Not Authenticated'] }, status: :unauthorized
    end

    private

    def auth_token
      @auth_token ||= JsonWebToken.decode(auth_header_value)
    end

    def user_id_in_token?
      auth_header_value && auth_token && user_id_in_token.to_i
    end

    def auth_header_value
      @auth_header_value ||= request.headers['Authorization']&.split(' ')&.last
    end

    def user_id_in_token
      auth_token&.dig(:user_id)
    end

    def jwt_payload(user)
      return nil unless user&.id

      user.as_json.merge(token: JsonWebToken.encode(user_id: user.id))
    end
  end
end
