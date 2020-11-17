module ExternalChannel
  class BaseSaver
    NO_COMPANY_NAME = 'NO COMPANY MATCH'.freeze
    NO_COMPANY_DESC =
      'This Company is prepared to protect server from expected that the external sales channels doesn\'t serve the profer brand data.
      DO NOT DELETE THIS COMPANY.'.freeze
    NO_BRAND_NAME = 'NO BRAND MATCH'.freeze

    def save_all(data)
      data.all? { |each| save(each) }
    end

    # === Saver는 저장 책임만 진다.
    # === 저장에 실패한 뒤의 로직은 saver 밖에서 처리해야 한다.
    def save(data)
      ActiveRecord::Base.transaction do
        save_data(data)
      rescue StandardError => e
        ActiveRecord::Rollback
        Rails.logger.error "#{Time.now} | Error : #{e.inspect} occured\nFIND here:\n#{e.backtrace}"
      end
    end

    protected

    attr_reader :country_code

    # === 실제로 데이터를 저장하는 로직이 담기는 함수이다.
    # === 하위 클래스에서는 이 부분을 구현하는 경우가 많다.
    def save_data(data); end

    def find_brand(brand_name)
      # 현재 DB에 있는 브랜드 중 &등 특수문자를 쓴 경우, rails에 의해 유니코드로 escape된다.
      # 이 데이터는 루비 orm에 의해 쿼리의 파라비터로 변환되는데, 이때 \문자가 escape 된다.
      # 이것이 DB에 들어갈 때, mysql은 \문자를 보고 또 escape를 한다.
      # & => \u0026 => \\u0026 => \\\\u0026
      brand_name = brand_name.gsub('&amp;', '&').to_json.gsub('&amp;', '&').gsub(/[\\*+?()|]/, '\\\\\\').downcase
      found_brand = Brand.where(
        "LOWER(JSON_EXTRACT(name, '$.#{Country.send(ApplicationRecord.country_code).locale}')) LIKE ?",
        brand_name.to_s.downcase
      ).first

      # 브랜드를 못찾으면 브랜드가 지정되지 않았다는 의미로 생성
      found_brand = no_brand if found_brand.nil?

      found_brand
    end

    private

    def no_brand
      # NO BRAND MATCH 라는 브랜드를 찾음
      no_brand = Brand.find_or_create_by(eng_name: NO_BRAND_NAME, company: no_company)
      return no_brand unless no_brand.id.nil?

      # TODO: 지금 이름이 vn이랑 vi랑 섞여서 기록되어 있다. 확인이 필요하다.
      # 이름이 없으면 만들어 줌
      brand_title = { en: NO_BRAND_NAME, ko: NO_BRAND_NAME }
      brand_title[Country.send(ApplicationRecord.country_code).locale.to_sym] = NO_BRAND_NAME
      no_brand.name ||= brand_title

      # 원래 없었으면 저장함
      no_brand.save!

      no_brand
    end

    def no_company
      no_company = Company.find_or_create_by(name: NO_COMPANY_NAME, description: NO_COMPANY_DESC)
      no_company.save! if no_company.id.nil?
      no_company
    end
  end
end
