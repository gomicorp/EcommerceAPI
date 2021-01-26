# ActionView::Template.register_template_handler :jbuilder, JbuilderHandler
# require 'jbuilder/dependency_tracker'

module Api
  module V1
    class BaseController < ActionController::Base
      include ErrorHandler
      skip_before_action :verify_authenticity_token
      before_action :set_default_format
      before_action :set_raven_context
      before_action :set_app_locale
      around_action :set_country_context

      NotAuthorized = Class.new(StandardError)


      def render_resource(resource)
        if resource.errors.empty?
          render json: resource
        else
          validation_error(resource)
        end
      end

      def validation_error(resource)
        render json: {
          errors: [
            {
              status: '400',
              title: 'Bad Request',
              detail: resource.errors,
              code: '100'
            }
          ]
        }, status: :bad_request
      end

      protected

      def authenticate_request!
        return render json: { errors: ['Not Authenticated2'] }, status: :unauthorized unless user_id_in_token?

        @current_user = User.find(user_id_in_token)
      rescue JWT::VerificationError, JWT::DecodeError
        render json: { errors: ['Not Authenticated3'], auth_header_value: auth_header_value }, status: :unauthorized
      end

      def decorator_class
        decorate_name.constantize
      end

      def decorate_name
        params.permit(:deco_type)[:deco_type].presence || default_decorator_name
      end

      def default_decorator_name
        # 'Companies::DefaultDecorator'
      end

      private

      def set_default_format
        params[:format] ||= :json
      end

      def set_raven_context
        return unless %w[production staging partner].include?(Rails.env)

        # Raven.user_context(id: session[:current_user_id]) # or anything else in session
        Raven.extra_context(
          params: params.to_unsafe_h,
          url: request.url,
          locale: I18n.locale
        )
      end

      def set_app_locale
        I18n.default_locale = :ko
      end

      def set_country_context
        if country_scope = params[:country_scope].presence
          scopes = [NationRecord.country_scope_for(country_scope)]
          NationRecord.default_scopes += scopes
          yield
          NationRecord.default_scopes -= scopes
        else
          yield
        end
      end

      def user_id_in_token
        auth_token&.dig(:user_id)
      end

      def user_id_in_token?
        auth_header_value && auth_token && user_id_in_token.to_i
      end

      def auth_token
        @auth_token ||= decode_jwt(auth_header_value)
      end

      def auth_header_value
        @auth_header_value ||= request.headers['Authorization']&.split(' ')&.last
      end

      def decode_jwt(token)
        JsonWebToken.decode(token)
      end

      def jwt_payload(user)
        return nil unless user&.id

        user.as_json.merge(token: user.authentication_token)
      end
    end
  end
end
