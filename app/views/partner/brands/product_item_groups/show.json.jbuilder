json.partial! "partner/brands/product_item_groups/product_item_group", product_item_group: @product_item_group

json.product_items @product_item_group.items do |item|
  json.except! item
  json.url partner_brand_product_item_url(@brand, item, format: :json)
end

json.brand do
  json.except! @brand
  json.url partner_brand_url(@brand, format: :json)
end
