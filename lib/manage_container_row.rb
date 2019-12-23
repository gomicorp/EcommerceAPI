module ManageContainerRow
  #product_item_container를 추가한다.
  def create_product_item_container(name)
    object = ProductItemContainer.create(
      :name => name
    )
    return object
  end

  #product_item_row를 추가한다.
  def create_product_item_row(product_item_id, product_item_container_id, amount)
    object = ProductItemRow.create(
      :product_item_id => product_item_id,
      :product_item_container_id => product_item_container_id,
      :amount => amount
    )
    return object
  end
end
