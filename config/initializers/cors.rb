Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins(
      if Rails.env == 'development'
        '*'
      elsif Rails.env == 'staging' || 'production'
        Rails.application.credentials.dig(:cors_whitelist)
      end
    )
    resource(
      '*',
      headers: :any,
      methods: %i[get post put patch delete options head],
      expose: %w[Authorization]
    )
  end
end
