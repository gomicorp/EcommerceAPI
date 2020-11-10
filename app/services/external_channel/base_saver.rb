module ExternalChannel
  class BaseSaver
    include ParseCountryCode

    def initialize(caller_country_code = nil)
      country_code=(caller_country_code || default_country_code)
    end

    def save_all(data)
      data.all? {|each| save(each)}
    end

    # === Saver는 저장 책임만 진다.
    # === 저장에 실패한 뒤의 로직은 saver 밖에서 처리해야 한다.
    def save(data)
      ActiveRecord::Base.transaction do
        begin
          save_data(data)
        rescue Exception => e
          ActiveRecord::Rollback
          e
        end
      end
    end

    protected

    # === 실제로 데이터를 저장하는 로직이 담기는 함수이다.
    # === 하위 클래스에서는 이 부분을 구현하는 경우가 많다.
    def save_data(data); end

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