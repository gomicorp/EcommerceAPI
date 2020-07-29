class ApiController < ActionController::API
  before_action :set_raven_context, :set_app_locale, :set_country_code

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

  private

  def set_raven_context
    return unless %w[production staging].include?(Rails.env)

    # Raven.user_context(id: session[:current_user_id]) # or anything else in session
    Raven.extra_context(
      params: params.to_unsafe_h,
      url: request.url,
      locale: I18n.locale
    )
  end

  def set_country_code
    @nation = params[:nation]
    ApplicationRecord.country_code = @nation
  end

  def set_app_locale
    I18n.default_locale = :ko
  end
end
