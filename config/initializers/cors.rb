Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    Rails.application.credentials.dig(:cors_whitelist).each do |host|
      origins host
    end
    resource(
      '*',
      headers: :any,
      methods: %i[get post put patch delete options head],
      expose: %w[Authorization]
    )
  end
end
