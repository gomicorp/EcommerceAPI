type = %w[ProductItem ProductCollection]
sample_item = ProductItem.select{ |item| item.available_quantity > 0 }
sample_collection = ProductCollection.select{ |collection| collection.available_quantity > 0 }

ApplicationRecord.transaction do
  ProductOption.where.not(bridges: ProductOptionBridge.all).each do |option|
    if type.sample == "ProductItem"
      connectable = sample_item.sample
    else
      connectable = sample_collection.sample
    end

    option.connect_with connectable

    ProductOptionBridge.all.each do |bridge|
      if bridge.product_option.product
        bridge.calculate_price_columns
        bridge.save!
      end
    end
  end
end