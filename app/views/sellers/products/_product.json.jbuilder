json.product do
  json.default_info product
  json.thumbnail_url url_for(product.thumbnail)
end
