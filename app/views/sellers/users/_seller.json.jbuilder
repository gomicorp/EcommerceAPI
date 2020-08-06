json.seller do
  json.default_info seller
  json.seller_info do
    json.default_info seller.seller_info
    json.store_info do
      json.default_info seller.seller_info.store_info
      json.products seller.seller_info.store_info.products do |product|
        json.default_info product
        json.thumbnail_url url_for(product.thumbnail)
      end
    end
  end
end
