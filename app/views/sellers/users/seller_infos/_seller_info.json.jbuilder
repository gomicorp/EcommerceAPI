json.seller_info do
  json.default_info seller_info
  json.store_info do
    json.default_info seller_info.store_info
    json.products seller_info.store_info.products
  end
end
