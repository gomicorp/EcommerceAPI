module ZohoManageAdjustment
  include ZohomapLib

  # adjustments 들을 생성한다.
  def create_adjustments(adjustment_datas)
    objects = []

    adjustment_datas.each do |adjustment_data|  
      # adjustment 유뮤 확인
      zoho_object = object_by_zoho_id(adjustment_data["inventory_adjustment_id"])

      # adjustment 없으면 create, 있으면 update (update는 작성예정)
      if zoho_object
        objects.push(zoho_object.zohoable)
      else
        object = create_adjustment(adjustment_data)
        create_zohomap(object, adjustment_data["inventory_adjustment_id"])
        adjustment_detail_data = get_action($access_token, adjustment_data["inventory_adjustment_id"])
        create_adjustment_product_items(object, adjustment_detail_data["inventory_adjustment"]["line_items"])
        objects.push(object)
      end
      
    end

    return objects
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
end
