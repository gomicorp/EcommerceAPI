module Gomisa
  module Zoho
    class ProductItemContainerSaver < Saver
      include ::ZohomapLib

      private

      def fetch
        @res = get_composite_items(access_token, @page += 1)
      end

      def save(resources)
        create_composite_items(resources, access_token)
      end

      def subjects
        res['composite_items']
      end

      #================================================================================

      # composite item들을 만든다
      def create_composite_items(datas, access_token)
        datas.each do |data|
          status = data['status']

          zoho_object = object_by_zoho_id(data['composite_item_id'])
          if zoho_object == nil
            if status == 'active'
              data = get_composite_item(access_token, data['composite_item_id'])
              create_composite_item(data)
            end
          elsif status == 'active'
            zoho_object.archived_at = nil
            zoho_object.save
            zoho_object.zohoable.product_item_rows.destroy_all
            data = get_composite_item(access_token, data['composite_item_id'])
            create_rows_of_composite_item(zoho_object.zohoable, data['composite_item']['mapped_items'])
          else
            zoho_object.archived_at = Time.zone.now
            zoho_object.save
          end
        end
      end

      #composite item을 만든다
      def create_composite_item(object)
        object = object["composite_item"]
        container = create_product_item_container(object["name"])
        create_rows_of_composite_item(container, object["mapped_items"])
        create_zohomap(container, object["composite_item_id"],  object["last_modified_time"])
      end

      #composite item의 row들을 만든다.
      def create_rows_of_composite_item(container, row_datas)
        row_datas.each do |row_data|
          product_item = object_by_zoho_id(row_data["item_id"]).zohoable
          quantity = row_data["quantity"].to_i
          create_product_item_row(product_item[:id], container[:id], quantity)
        end
      end


      #product_item_container를 추가한다.
      def create_product_item_container(name)
        ProductItemContainer.create(name: name)
      end

      #product_item_row를 추가한다.
      def create_product_item_row(product_item_id, product_item_container_id, amount)
        ProductItemRow.create(
          product_item_id: product_item_id,
          product_item_container_id: product_item_container_id,
          amount: amount
        )
      end
    end
  end
end
