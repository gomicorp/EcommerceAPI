module Gomisa
  module Zoho
    class AdjustmentSaver < Saver
      include ::ZohomapLib

      def call
        zoho_ids = []

        while has_more_page?
          fetch 
          zoho_ids = zoho_ids +save(subjects)
        end

        archive_adjustments(zoho_ids)
      end

      private

      def fetch
        @res = get_actions(access_token, @page += 1)
      end

      def save(resources)
        return create_adjustments(resources)
      end

      def subjects
        res['inventory_adjustments']
      end

      #================================================================================

      # adjustments 들을 생성한다.
      def create_adjustments(adjustment_datas)
        objects = []
        zoho_ids = []

        adjustment_datas.each do |adjustment_data|
          zoho_ids.push(adjustment_data["inventory_adjustment_id"].to_s)
          # adjustment 유뮤 확인
          zoho_object = object_by_zoho_id(adjustment_data["inventory_adjustment_id"])

          # adjustment 없으면 create, 있으면 update (update는 작성예정)
          if zoho_object 
            if zoho_object[:zoho_updated_at] != adjustment_data['last_modified_time']
              object = create_or_update_adjustment(adjustment_data)
              #object = zoho_object.zohoable
              adjustment_detail_data = get_action($access_token, adjustment_data['inventory_adjustment_id'])
              object.adjustment_product_items.destroy_all
              create_adjustment_product_items(object, adjustment_detail_data['inventory_adjustment']['line_items'])
              #zoho_object[:zoho_updated_at] = adjustment_data['last_modified_time']
              #zoho_object.save
              objects.push(object)
            end
          else
            # object = create_adjustment(adjustment_data)
            object = create_or_update_adjustment(adjustment_data)
            # create_zohomap(object, adjustment_data['inventory_adjustment_id'], adjustment_data['last_modified_time'])
            adjustment_detail_data = get_action($access_token, adjustment_data['inventory_adjustment_id'])
            create_adjustment_product_items(object, adjustment_detail_data['inventory_adjustment']['line_items'])
            objects.push(object)
          end
        end

        return zoho_ids
      end

      # adjustment를 생성한다
      def create_adjustment(data)
        channel, order_id = data["reference_number"].split('-')
        object = Adjustment.create(
          :reason => data["reason"],
          :channel => channel,
          :order_id => order_id.to_i,
          :exported_at => data["date"]
        )
        return object
      end

      # adjustment를 생성하거나 업데이트 한다
      def create_or_update_adjustment(data)
        channel, order_id = data['reference_number'].split('-')
        obj = Adjustment.find_or_create_by(
          zohomap: Zohomap.find_or_initialize_by(
            zoho_id: data['inventory_adjustment_id']
          )
        )
        obj.update(
          reason: data['reason'],
          channel: channel,
          order_id: order_id.to_i,
          exported_at: data['date']
        )
        obj.zohomap.update(
          zoho_updated_at: data['last_modified_time']
        )
        return obj
      end

      def create_zohomap(object, zoho_id, zoho_updated_at)
        Zohomap.create(
          :zohoable => object, 
          :zoho_id => zoho_id.to_s,
          :zoho_updated_at => zoho_updated_at
        )
      end

      # adjustment_product_item 중계 모델들을 생성한다
      def create_adjustment_product_items(adjustment, datas)
        datas.each do |data|
          create_adjustment_product_item_procedure(adjustment, data["item_id"], data["is_combo_product"], data["quantity_adjusted"])
        end
      end

      # adjustment_product_item 중계 모델을 생성하는 과정이다.
      # 만약 item_id가 combo item인경우에 다른 로직으로 처리해준다.
      def create_adjustment_product_item_procedure(adjustment, item_id, is_combo, quantity)
        is_positive = true

        if quantity < 0
          is_positive = false
          quantity = quantity * (-1)
        end

        if is_combo
          create_adjustment_product_item_combo_procedure(adjustment, item_id, quantity, is_positive)
        else
          create_adjustment_product_item(adjustment[:id], object_by_zoho_id(item_id)[:zohoable_id], quantity, is_positive)
        end
      end

      # item이 combo일때의 adjustment_product_item 중계 모델을 생성하는 과정이다.
      def create_adjustment_product_item_combo_procedure(adjustment, item_id, quantity, is_positive)
        container = object_by_zoho_id(item_id).zohoable
        rows = container.product_item_rows
        rows.each do |row|
          create_adjustment_product_item(adjustment[:id], row.product_item[:id], quantity * row["amount"], is_positive)
        end
      end

      # adjustment_product_item 중계 모델를 생성한다.
      def create_adjustment_product_item(adjustment_id, product_item_id, quantity, is_positive)
        AdjustmentProductItem.create(
          :adjustment_id => adjustment_id,
          :product_item_id => product_item_id,
          :quantity => quantity,
          :is_positive => is_positive
        )
      end

      # adjustment들을 archived 한다
      def archive_adjustments(zoho_ids)
        adjustments = Zohomap.where(
          zohoable_type: 'Adjustment'
        ).where.not(
          zoho_id: zoho_ids
        )
        adjustments.each do |adjustment|
          if adjustment['archived_at'] == nil
            adjustment.archived_at = Time.zone.now
            adjustment.save
          end
        end
      end
    end
  end
end
