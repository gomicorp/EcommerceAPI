module ExternalChannel
  module Product
    # TODO: 방어 로직 추가
    class Saver < BaseSaver
      protected

      def save_data(data)
        refresh_data
        @channel = Channel.find_by_name(data[:channel_name])
        raise ActiveRecord::RecordNotFound('NotFoundChannelError => The given channel doesn\'t exist on gomi back office.') if channel.nil?

        @brand = find_brand(data[:brand_name])
        save_product(data) && save_options(data[:variants])
      end

      private

      attr_reader :brand, :channel, :product

      def refresh_data
        @channel = @product = nil
      end

      def save_product(product_data)
        this_product_connection = ExternalChannelProductId.find_or_initialize_by(channel_id: channel.id, external_id: product_data[:id].to_s)
        product_id = this_product_connection.product ? this_product_connection.product_id : nil
        @product = ::Product.find_or_initialize_by(id: product_id)
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

      # TODO: 채널 어소시에이션을 걸어야 함.
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
          # TODO: 나중에는 국가별로 키값을 가지고 돌면서 title을 주입할 수 있도록 처리해야 함.
          { 'vi': title, 'en': "(not translated)#{title}", 'ko': "(미번역)#{title}" }
        end
      end
    end
  end
end
