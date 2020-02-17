json.partial! "gomisa/product_collections/product_collection", product_collection: @product_collection
#json.selling_price @product_collection.selling_price
#json.cost_price @product_collection.cost_price

json.items do
  json.array! @product_collection.lists
end
