json.array! @product_item_groups do |item_group|
  json.except! item_group
  json.brand item_group.brand, :id, :name
end

##
