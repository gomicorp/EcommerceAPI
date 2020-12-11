Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins(
      "https://partner.gomistore.com",
      "https://test-partner.gomistore.com",
      "https://gomistore.in.th",
      "https://staging.gomistore.in.th",
      "https://vn.gomistore.com",
      "https://vn-staging.gomistore.com"
    )
    resource(
      '*',
      headers: :any,
      methods: %i[get post put patch delete options head],
      expose: %w[Authorization]
    )
  end
end
