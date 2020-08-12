store_info = Seller.find(current_user.id)&.seller_info&.store_info

json.product do
  json.default_info product
  json.thumbnail_url product.thumbnail.service_url || url_for(product.thumbnail)
  json.default_option_title product.default_option.name
  json.category_ids product.categories&.ids
  json.is_selected Sellers::SelectedProduct.find_by(store_info: store_info, product: product).present?
end
