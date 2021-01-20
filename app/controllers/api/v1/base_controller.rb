# ActionView::Template.register_template_handler :jbuilder, JbuilderHandler
# require 'jbuilder/dependency_tracker'

module Api
  module V1
    class BaseController < ActionController::Base
      include ErrorHandler
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
    end
  end
end
