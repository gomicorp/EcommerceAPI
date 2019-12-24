module Gomisa
  module Zoho
    class ProductItemSaver < Saver
      private

      def fetch
        @res = get_items(access_token, @page += 1)
      end

      def save(product_items)
        product_items.map do |product_item|
          item_response = ProductItemResponse.new(product_item)

          return item_response.product_item if item_response.able_to_skip?

          item_response.create_product_item if item_response.need_to_create?
        end
      end

      def subjects
        res['items']
      end
    end


    class ProductItemResponse
      attr_reader :item_data
      attr_reader :item_id, :item_name, :item_group_id, :is_combo_product, :cost_price, :selling_price, :attribute_info_dataset
      attr_reader :brand, :item_group, :product_attributes

      def initialize(response)
        @item_data = response
        @item_id = item_data['item_id']
        @item_name = item_data['name']
        @item_group_id = item_data['group_id']
        @is_combo_product = item_data['is_combo_product']
        @cost_price = item_data['purchase_rate']
        @selling_price = item_data['rate']

        attribute_infos = item_data.select {|k, _v| k =~ /^(?=.*attribute)(?!.*option).*/}

        attributes = []
        attribute_infos.each do |k, v|
          index = k.to_s[/\d+$/].to_i - 1
          column = k.to_s.gsub(index.to_s, '').gsub('attribute_', '')
          attributes[index] ||= {}
          attributes[index][column.to_sym] = v
        end

        attribute_option_infos = item_data.select {|k, _v| k =~ /^(?=.*attribute)(?=.*option).*/}
        attribute_options = []
        attribute_option_infos.each do |k, v|
          index = k.to_s[/\d+$/].to_i - 1
          column = k.to_s.gsub(index.to_s, '').gsub('attribute_option_', '')
          attribute_options[index] ||= {}
          attribute_options[index][column.to_sym] = v
        end

        @attribute_info_dataset = attribute_options.map.with_index do |attribute_option_info, i|
          attribute_option_info[:attribute_info] = attributes[i]
        end
      end

      def able_to_skip?
        zohomap.present?
      end

      def need_to_create?
        @product_item.nil? && !is_combo_product
      end

      def zohomap
        @zohomap ||= Zohomap.find_by(zoho_id: item_id, zohoable_type: 'ProductItem')
      end

      def create_product_item
        # example: "name": "그라펜-스킨-로션-100ml/동그라미"
        brand_name, item_group_name, options = parse_item_name(item_name)

        # set brand instance (ㅇ)
        set_brand_by(name: brand_name)

        # product_item_group 저장 (ㅇ)
        set_item_group(name: item_group_name)

        # 속성id_1, 속성id_2, 속성id_3, 옵션id_1, 옵션id_2, 옴션id_3
        # 이따구로 들어옴;;;;
        # 순전히 Zoho 탓.
        if options.present?
          attribute_info_dataset.each do |option_info|
            attribute_info = option_info.delete(:attribute_info)

            product_attribute = ProductAttribute.find_or_create_by(
              name: attribute_info[:name],
              zohomap: Zohomap.find_or_initialize_by(zoho_id: attribute_info[:id])
            )

            ProductAttributeOption.find_or_create_by(
              product_attribute: product_attribute,
              name: option_info[:name],
              zohomap: Zohomap.find_or_initialize_by(zoho_id: option_info[:id])
            )

            unless item_group.product_attributes.exists? product_attribute
              item_group.product_attributes << product_attribute
              product_attribute
            end
          end
        end

        product_item
      end

      def product_item
        @product_item ||= zohomap.zohoable
      end

      private

      def parse_item_name(item_name_params)
        spread = item_name_params.split('-')
        brand_name = spread.shift
        options_name = spread.pop
        item_group_name = spread
        [brand_name, item_group_name, options_name]
      end

      def set_brand_by(**args)
        @brand = Brand.find_or_create_by(**args)
      end

      def set_item_group(name: nil)
        @item_group = ProductItemGroup.find_or_create_by(
          brand: brand,
          name: name,
          zohomap: Zohomap.find_or_initialize_by(
            zoho_id: item_group_id,
            zohoable_type: 'ProductItemGroup'
          )
        )
      end

      def set_product_item
        @product_item = item_group.items.create(
          name: item_name,
          cost_price: cost_price,
          selling_price: selling_price,
          zohomap: Zohomap.new(zoho_id: item_id)
        )
      end

      def set_product_item_container
        @product_item_container = ProductItemContainer.create(name: @product_item)
      end

      def set_product_item_row
        @product_item_row = ProductItemRow.create(
          product_item: @product_item,
          product_item_container: @product_item_container,
          amount: 1
        )
      end
    end
  end
end
