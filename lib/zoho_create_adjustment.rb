module ZohoCreateAdjustment
  # 현재 adjustment 가 존재하는지 확인한다
  def get_adjustment(id)
    adjustment = Adjustment.find_by(zoho_id: id)
    return adjustment
  end

  # adjustment를 생성한다
  def create_adjustment(data)
    object = Adjustment.create(
      :zoho_id => data["inventory_adjustment_id"].to_s,
      :reason => data["reason"],
      :channel => data["reference_number"]
    )
    return object
  end

  # adjustment_product_item 중계 모델을 생성한다
  def create_adjustment_product_item(adjustment, item_id, quantity)
    AdjustmentProductItem.create(
      :adjustment_id => adjustment[:id], 
      :product_item_id => item_id,
      :quantity => quantity
    )
  end

  # adjustment_product_item 중계 모델을 생성한다
  def create_adjustment_product_items(adjustment, datas)  
    datas.each do |data|
      create_adjustment_product_item(adjustment, data["item_id"], data["quantity_adjusted"])
    end
  end

  # adjustments 들을 생성한다.
  def create_adjustments(adjustment_datas)
    objects = []

    adjustment_datas.each do |adjustment_data|  
      # adjustment 유뮤 확인
      adjustment = get_adjustment(adjustment_data["inventory_adjustment_id"].to_s)

      # adjustment 없으면 create, 있으면 아무 행동도 일어나지 않는다
      if adjustment
        objects.push(adjustment)
      else
        adjustment = create_adjustment(adjustment_data)
        adjustment_detail_data = get_action($access_token, adjustment_data["inventory_adjustment_id"])
        create_adjustment_product_items(adjustment, adjustment_detail_data["inventory_adjustment"]["line_items"])
        objects.push(adjustment)
      end
      
    end

    return objects
  end
end
