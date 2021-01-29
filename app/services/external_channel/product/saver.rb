module ExternalChannel
  module Product
    # TODO: 방어 로직 추가
    class Saver < BaseSaver
      NO_COMPANY_NAME = 'NO COMPANY MATCH'.freeze
      NO_COMPANY_DESC =
        'This Company is prepared to protect server from expected that the external sales channels doesn\'t serve the profer brand data.
        DO NOT DELETE THIS COMPANY.'.freeze
      NO_BRAND_NAME = 'NO BRAND MATCH'.freeze

      protected

      def save_data(data)
        refresh_data
        @channel = Channel.find_by(country: Country.send(ApplicationRecord.country_code), name: data[:channel_name])
        raise ActiveRecord::RecordNotFound("NotFoundChannelError => The given channel #{data[:channel_name]} doesn\'t exist on gomi back office.") if channel.nil?

        save_product(data) && save_options(data[:variants])
      end

      private

      attr_reader :brand, :channel, :product

      def refresh_data
        @channel = @product = nil
      end

      def save_product(product_data)
        this_product_connection = ExternalChannel::ProductMapper.find_or_initialize_by(country: Country.send(ApplicationRecord.country_code),
                                                                                       channel_id: channel.id,
                                                                                       external_id: product_data[:id].to_s)
        product_id = this_product_connection.product ? this_product_connection.product_id : nil
        @product = ::Product.find_or_initialize_by(country: Country.send(ApplicationRecord.country_code), id: product_id)
        @brand = find_brand(product_data[:brand_name]) || product.brand || temp_brand

        product.assign_attributes(parse_product(product_data, product.attributes))
        result = product.save!

        if product_id.nil? && result
          this_product_connection.update({ channel: channel, product: product, external_id: product_data[:id].to_s })
        end

        result
      end

      def save_options(options)
        option_group = product.option_groups.first_or_create
        options.all? { |option| save_option(option, option_group) }
      end

      def save_option(option, option_group)
        product_option_data = parse_product_option(option)
        # TODO: 모델 구조 변경시 코드 변경 필요
        product_option = product.options.find_by(channel_code: option[:id])
        if product_option.nil?
          option_group.options << ProductOption.new(product_option_data)
        else
          product_option.update!(product_option_data)
        end
      end

      def parse_product(product, default_product = {})
        {
          brand_id: brand.id,
          running_status: default_product['running_status'] || 'pending',
          title: make_valid_title(product[:title])
        }
      end

      def parse_product_option(variant)
        {
          name: variant[:name],
          channel: channel,
          channel_id: channel.id,
          channel_code: variant[:id],
          additional_price: variant[:price]
        }
      end

      # TODO: 지금 이름이 vn이랑 vi랑 섞여서 기록되어 있다. 확인이 필요하다.
      def make_valid_title(title)
        if product.title.nil? == false
          parsed_product = JSON.parse(product.title)
          parsed_product[Country.send(ApplicationRecord.country_code).locale] = title
          parsed_product
        else
          data = { 'en': "(not translated)#{title}", 'ko': "(미번역)#{title}" }
          data[Country.send(ApplicationRecord.country_code).locale] = title
          data
        end
      end

    
      # === 브랜드 찾기
      def find_brand(brand_name)
        Brand.where(
          "REPLACE(LOWER(subtitle), ' ', '') LIKE ?",
          brand_name.gsub(' ', '').downcase
        ).where(country: Country.send(ApplicationRecord.country_code)).first
      end

      # === 브랜드가 없을 경우 임시 브랜드 생성/할당
      def temp_brand
        # NO BRAND MATCH 라는 브랜드를 찾음
        no_brand = Brand.find_or_initialize_by(subtitle: NO_BRAND_NAME, company: temp_company)
        return no_brand unless no_brand.new_record?

        # TODO: 지금 이름이 vn이랑 vi랑 섞여서 기록되어 있다. 확인이 필요하다.
        # 이름이 없으면 만들어 줌
        brand_title = { en: NO_BRAND_NAME, ko: NO_BRAND_NAME }
        brand_title[Country.send(ApplicationRecord.country_code).locale] = NO_BRAND_NAME
        no_brand.name ||= brand_title

        # 원래 없었으면 저장함
        no_brand.save!

        no_brand
      end

      def temp_company
        no_company = Company.find_or_create_by(name: NO_COMPANY_NAME, description: NO_COMPANY_DESC)
        no_company.save! if no_company.id.nil?
        no_company
      end
    end
  end
end
