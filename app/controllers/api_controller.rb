class ApiController < ActionController::API
  before_action :set_raven_context, :set_app_locale, :set_country_code

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
