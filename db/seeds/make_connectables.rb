type = %w[ProductItem ProductCollection]
sample_item = ProductItem.select{ |item| item.available_quantity > 0 }
sample_collection = ProductCollection.select{ |collection| collection.available_quantity > 0 }

ApplicationRecord.transaction do
  ProductOption.where(bridges: ProductOptionBridge.all).each do |option|
    if type.sample == "ProductItem"
      connectable = sample_item.sample
    else
      connectable = sample_collection.sample
    end

    option.connect_with connectable
  end
end