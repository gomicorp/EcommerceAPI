# frozen_string_literal: true

module Partner
  class BaseController < ApiController
    before_action :set_app_locale
    attr_reader :current_user

    # CRUD stuff
    def index; end

    # CRUD stuff
    def show; end

    # CRUD stuff
    def new; end

    # CRUD stuff
    def create; end

    # CRUD stuff
    def edit; end

    # CRUD stuff
    def update; end

    # CRUD stuff
    def destroy; end

    protected

    def set_app_locale
      I18n.default_locale = :ko
    end

    def authenticate_request!
      return render json: { errors: ['Not Authenticated'] }, status: :unauthorized unless user_id_in_token?

      @current_user = Manager.find(user_id_in_token)
    rescue JWT::VerificationError, JWT::DecodeError
      render json: { errors: ['Not Authenticated'] }, status: :unauthorized
    end

    private

    def decode_jwt(token)
      JsonWebToken.decode(token)
    end

    def auth_token
      @auth_token ||= decode_jwt(auth_header_value)
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
