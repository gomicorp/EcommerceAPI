class ApiController < ActionController::API
  before_action :set_raven_context

  private

  def set_raven_context
    return unless production?

    # Raven.user_context(id: session[:current_user_id]) # or anything else in session
    Raven.extra_context(
      params: params.to_unsafe_h,
      url: request.url,
      locale: I18n.locale
    )
  end
end
