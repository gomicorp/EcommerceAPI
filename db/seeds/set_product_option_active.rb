target_options = ProductOption.inactive.where(product: Product.all)

ApplicationRecord.transaction do
  target_options.each do |option|
    option.update!(active: true)
  end
end