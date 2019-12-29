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
          
          if item_response.able_to_skip?
            if item_response.need_to_archive?
              item_response.archive_product_item
            elsif item_response.need_to_update?
              item_response.update_product_item
            else
              item_response.product_item 
            end
          elsif item_response.need_to_create?
            item_response.create_product_item
          end
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
      attr_reader :zoho_updated_at, :status

      def initialize(response)
        @item_data = response
        @item_id = item_data['item_id']
        @item_name = item_data['name']
        @item_group_id = item_data['group_id']
        @is_combo_product = item_data['is_combo_product']
        @cost_price = item_data['purchase_rate']
        @selling_price = item_data['rate']
        @zoho_updated_at = item_data['last_modified_time']
        @status = item_data['status']

        attribute_infos = item_data.select {|k, _v| k =~ /^(?=.*attribute)(?!.*option).*/}

        attributes = []
        attribute_infos.each do |k, v|
          index = k.to_s[/\d+$/].to_i - 1
          column = k.to_s.gsub(index.to_s, '').gsub('attribute_', '').gsub(/\d/, '')
          if v != ''
            attributes[index] ||= {}
            attributes[index][column.to_sym] = v
          end
        end

        attribute_option_infos = item_data.select {|k, _v| k =~ /^(?=.*attribute)(?=.*option).*/}
        attribute_options = []
        attribute_option_infos.each do |k, v|
          index = k.to_s[/\d+$/].to_i - 1
          column = k.to_s.gsub(index.to_s, '').gsub('attribute_option_', '').gsub(/\d/, '')
          if v != ''
            attribute_options[index] ||= {}
            attribute_options[index][column.to_sym] = v
          end
        end

        @attribute_info_dataset = attribute_options.map.with_index do |attribute_option_info, i|
          attribute_option_info[:attribute_info] = attributes[i]
          attribute_option_info
        end
      end

      def able_to_skip?
        zohomap.present?
      end

      def need_to_update?
        @zohomap[:zoho_updated_at] < zoho_updated_at.to_datetime.in_time_zone
      end

      def need_to_archive?
        status == 'inactive'
      end

      def need_to_create?
        @product_item.nil? && !is_combo_product && status != 'inactive'
      end

      def zohomap
        @zohomap ||= Zohomap.find_by(zoho_id: @item_id, zohoable_type: 'ProductItem')
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
          @attribute_info_dataset.each do |option_info|
            attribute_info = option_info.delete(:attribute_info)
            
            product_attribute = ProductAttribute.find_or_create_by(
              name: attribute_info[:name],
              zohomap: Zohomap.find_or_initialize_by(
                zoho_id: attribute_info[:id]
              )
            )

            ProductAttributeOption.find_or_create_by(
              product_attribute: product_attribute,
              name: option_info[:name],
              zohomap: Zohomap.find_or_initialize_by(
                zoho_id: option_info[:id]
              )
            )

            unless item_group.product_attributes.exists? product_attribute[:id]
              item_group.product_attributes << product_attribute
              product_attribute
            end
          end
        end
        set_product_item
        set_product_item_container
        set_product_item_row
      end

      def update_product_item
        # example: "name": "그라펜-스킨-로션-100ml/동그라미"
        brand_name, item_group_name, options = parse_item_name(item_name)

        # set brand instance (ㅇ)
        set_brand_by(name: brand_name)

        # product_item_group 저장 (ㅇ)
        update_item_group(name: item_group_name)

        # 속성id_1, 속성id_2, 속성id_3, 옵션id_1, 옵션id_2, 옴션id_3
        # 이따구로 들어옴;;;;
        # 순전히 Zoho 탓.
        if options.present?
          @attribute_info_dataset.each do |option_info|
            attribute_info = option_info.delete(:attribute_info)
            
            zoho_object = Zohomap.find_by(zoho_id: attribute_info[:id])
            if zoho_object == nil
              product_attribute = ProductAttribute.find_or_create_by(
                name: attribute_info[:name],
                zohomap: Zohomap.find_or_initialize_by(
                  zoho_id: attribute_info[:id],
                  zoho_updated_at: zoho_updated_at.to_datetime.in_time_zone
                )
              )
            elsif zoho_object.zohoable[:name] != attribute_info[:name]
              update_object(zoho_object.zohoable, attribute_info[:name])
              update_zoho_object(zoho_object)
              product_attribute = zoho_object.zohoable
            else
              product_attribute = zoho_object.zohoable
            end
            
            zoho_object = Zohomap.find_by(zoho_id: option_info[:id])
            if zoho_object == nil
              ProductAttributeOption.find_or_create_by(
                product_attribute: product_attribute,
                name: option_info[:name],
                zohomap: Zohomap.find_or_initialize_by(
                  zoho_id: option_info[:id],
                  zoho_updated_at: zoho_updated_at.to_datetime.in_time_zone
                )
              )
            elsif zoho_object.zohoable[:name] != option_info[:name]
              update_object(zoho_object.zohoable, option_info[:name])
              update_zoho_object(zoho_object)
            end

            unless item_group.product_attributes.exists? product_attribute[:id]
              item_group.product_attributes << product_attribute
              product_attribute
            end
          end
        end
        update_product_item_container
        reset_product_item
      end

      def archive_product_item
        zoho_object = Zohomap.find_by(zoho_id: item_id)
        zoho_object.archived_at = Time.zone.now 
        zoho_object.save
      end

      def product_item
        @product_item ||= zohoable
      end

      def zohoable
        temp = zohomap
        return temp.zohoable if temp
      end

      private

      def parse_item_name(item_name_params)
        spread = item_name_params.split('-')
        brand_name = spread.shift
        options_name = spread.pop
        item_group_name = spread.join('-')
        [brand_name, item_group_name, options_name]
      end
      
      def set_brand_by(**args)
        @brand = Brand.find_by(name: args[:name])
        if @brand == nil
          @brand = Brand.new
          @brand[:name] = args[:name]
          @brand.save
        end
      end

      def set_item_group(name: nil)
        zoho_object = Zohomap.find_by(zoho_id: item_group_id.to_s)
        unless zoho_object
          object = @brand.product_item_groups.create(name: name)
          zoho_object = Zohomap.create(
            zoho_id: item_group_id.to_s,
            zohoable: object
          )
        end
        @item_group = zoho_object.zohoable
      end

      def update_item_group(name: nil)
        zoho_object = Zohomap.find_by(zoho_id: item_group_id)
        if zoho_object 
          if zoho_object.zohoable[:name] != name
            update_object(zoho_object.zohoable, name)
            update_zoho_object(zoho_object)
          end
          @item_group = zoho_object.zohoable
        else
          set_item_group(name)
        end
      end

      def set_product_item
        @product_item = item_group.items.create(
          name: item_name,
          cost_price: cost_price,
          selling_price: selling_price,
          zohomap: Zohomap.new(
            zoho_id: item_id,
            zoho_updated_at: zoho_updated_at.to_datetime.in_time_zone
          )
        )
      end

      def reset_product_item
        zoho_object = Zohomap.find_by(zoho_id: item_id)
        zoho_object.archived_at = nil
        zoho_object.save

        @product_item = zoho_object.zohoable
        @product_item[:name] = item_name
        @product_item[:cost_price] = cost_price
        @product_item[:selling_price] = selling_price
        @product_item.save
        update_zoho_object(zoho_object)
      end

      def set_product_item_container
        @product_item_container = ProductItemContainer.create(name: @product_item[:name])
      end

      def update_product_item_container
        zoho_object = Zohomap.find_by(zoho_id: item_id)
        @product_item = zoho_object.zohoable
        @product_item_container = ProductItemContainer.find_by(name: @product_item[:name])
        update_object(@product_item_container, item_name)
      end

      def set_product_item_row
        @product_item_row = ProductItemRow.create(
          product_item: @product_item,
          product_item_container: @product_item_container,
          amount: 1
        )
      end
      
      def update_object(object, name)
        object[:name] = name
        object.save
      end

      def update_zoho_object(zoho_object)
        zoho_object[:zoho_updated_at] = zoho_updated_at
        zoho_object.save
      end
    end
  end
end
