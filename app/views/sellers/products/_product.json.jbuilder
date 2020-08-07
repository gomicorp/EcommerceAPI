json.product do
  json.default_info product
  json.thumbnail_url url_for(product.thumbnail)
  json.default_option_title product.default_option.name
end
