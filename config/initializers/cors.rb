Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins(
      'https://partner.gomistore.com',        # = 파트너센터
      'https://test-partner.gomistore.com',   # = 스테이징 파트너센터
      'https://vn.gomistore.com',             # = 베트남 고미스토어
      'https://vn-staging.gomistore.com',     # = 베트남 스테이징 고미스토어
      'https://gomistore.in.th',              # = 태국 고미스토어
      'https://staging.gomistore.in.th'       # = 태국 스테이징 고미스토어
    )
    resource(
      '*',
      headers: :any,
      methods: %i[get post put patch delete options head],
      expose: %w[Authorization]
    )
  end
end
