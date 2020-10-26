module ExternalChannel
  class ExternalChannelSaver
    include ParseCountryCode

    def initialize(caller_country_code = country_code)
      country_code=(caller_country_code)
    end

    def save_all(data); end

    def save(data); end

    protected

    def find_brand(brand_name)
      # 현재 DB에 있는 브랜드 중 &등 특수문자를 쓴 경우, rails에 의해 유니코드로 escape된다.
      # 이 데이터는 루비 orm에 의해 쿼리의 파라비터로 변환되는데, 이때 \문자가 escape 된다.
      # 이것이 DB에 들어갈 때, mysql은 \문자를 보고 또 escape를 한다.
      # & => \u0026 => \\u0026 => \\\\u0026
      brand_name = brand_name.gsub('&amp;', '&').to_json.gsub('&amp;', '&').gsub(/[\\\*\+\?\()\|]/, '\\\\\\').downcase
      Brand.where("LOWER(JSON_EXTRACT(name, '$.#{country_code}')) LIKE ?", "#{brand_name}").first
    end
  end
end