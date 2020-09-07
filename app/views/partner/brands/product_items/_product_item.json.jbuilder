json.except! product_item
json.url partner_brand_product_item_url(@brand, product_item, format: :json)

json.product_item_group do
  group = product_item.item_group
  json.except! group
  json.url partner_brand_product_item_group_url(@brand, group, format: :json)
end

json.brand do
  json.except! @brand
  json.url partner_brand_url(@brand, format: :json)
end
