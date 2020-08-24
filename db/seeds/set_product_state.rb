target_products = Product.where(running_status: "sold_out").select{ |a| a.default_option.available_quantity > 0 }

ApplicationRecord.transaction do
  target_products.each do |product|
    product.update(running_status: "running")
  end
end
