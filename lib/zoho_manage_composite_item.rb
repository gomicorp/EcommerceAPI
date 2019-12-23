module ZohoManageCompositeItem
  include ZohoRequest, ZohomapLib, ManageContainerRow

  # composite item들을 만든다
  def create_composite_items(datas, access_token)
    datas.each do |data|  
      if object_by_zoho_id(data["composite_item_id"]) == nil
        data = get_composite_item(access_token, data["composite_item_id"])
        create_composite_item(data)
      end
    end
  end

  #composite item을 만든다
  def create_composite_item(object)
    object = object["composite_item"]
    container = create_product_item_container(object["name"])
    create_rows_of_composite_item(container, object["mapped_items"])
    create_zohomap(container, object["composite_item_id"])
  end

  #composite item의 row들을 만든다.
  def create_rows_of_composite_item(container, row_datas)
    row_datas.each do |row_data|
      product_item = object_by_zoho_id(row_data["item_id"]).zohoable
      quantity = row_data["quantity"].to_i
      create_product_item_row(product_item[:id], container[:id], quantity)
    end
  end
end
