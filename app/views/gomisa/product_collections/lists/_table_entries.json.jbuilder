json.cost_price list.item.cost_price
json.selling_price list.item.selling_price
json.alive_barcodes_count list.item.alive_barcodes_count
json.unit_count list.unit_count
json.available_quantity list.available_quantity

json.item do
  json.id list.item.id
  json.name list.item.name
  json.url gomisa_product_item_url(list.item)
end
