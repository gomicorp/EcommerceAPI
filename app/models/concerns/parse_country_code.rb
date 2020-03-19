module ParseCountryCode
  def country_code
    @country_code ||= 'th'
  end

  def country_code=(code)
    @country_code = (code || 'th').downcase
  end

  def country_context_with(code, &block)
    original_code = country_code
    self.country_code = code
    yield if block_given?
    self.country_code = original_code
  end
end
