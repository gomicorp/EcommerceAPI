Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    permitted_origin = {
      development: '*',
      test: '*',
      staging: Rails.application.credentials.dig(:cors_whitelist),
      production: Rails.application.credentials.dig(:cors_whitelist)
    }[Rails.env.to_sym]

    origins(permitted_origin)
    resource(
      '*',
      headers: :any,
      methods: %i[get post put patch delete options head],
      expose: %w[Authorization]
    )
  end
end
