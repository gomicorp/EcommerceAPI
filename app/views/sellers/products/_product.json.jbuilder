store_info = Seller.find(current_user.id).seller_info.store_info if current_user

json.product product

if ENV['RAILS_ENV'] == 'development'
  json.thumbnail_url url_for(product.thumbnail)
else
  json.thumbnail_url product.thumbnail.service_url
end

json.default_option_title product.default_option.name
json.default_option_price product.default_option.retail_price
json.category_ids product.categories&.ids
json.is_selected Sellers::SelectedProduct.find_by(store_info: store_info, product: product).present? || false
