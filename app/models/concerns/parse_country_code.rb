module ParseCountryCode
  def country_code
    @country_code ||= 'th'
  end

  def country_code=(code)
    @country_code = (code || 'th').downcase
  end
end
