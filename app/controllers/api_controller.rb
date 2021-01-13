class ApiController < ActionController::API
  respond_to :json

  before_action :set_raven_context, :set_app_locale, :set_country_code

  NotAuthorized = Class.new(StandardError)

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render_error_page(status: 404, text: 'Not found')
  end

  rescue_from ApiController::NotAuthorized do |exception|
    render_error_page(status: 403, text: 'Forbidden')
  end

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
    return unless %w[production staging partner didimdol].include?(Rails.env)

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

  private def render_error_page(status:, text:)
    respond_with do |format|
      format.json { render json: {errors: [message: "#{status} #{text}"]}, status: status }
      format.any  { head status }
    end
  end
end
