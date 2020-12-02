Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins(
      'sellers.gomistore.in.th',            # 디딤돌용 셀러즈 모바일앱
      'sellers.gomistore.com',              # 디딤돌용 고미스토어 (+팝업스토어)
      'partners.gomistore.com',             # 디딤돌용 파트너센터
      'https://test-partner.gomistore.com', # 스테이징 파트너센터
      'partner.gomistore.com'
    )
    resource(
      '*',
      headers: :any,
      methods: %i[get post put patch delete options head],
      expose: %w[Authorization]
    )
  end
end
