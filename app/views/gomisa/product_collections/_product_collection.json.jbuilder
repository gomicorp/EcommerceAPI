json.extract! product_collection, :id, :created_at, :updated_at
json.count product_collection.elements.count
json.available_quantity product_collection.available_quantity
json.url gomisa_product_collection_url(product_collection, format: :json)
