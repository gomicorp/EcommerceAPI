ApplicationRecord.transaction do
  ProductOptionGroup.select{|a| a.options.count == 0}.each do |option_group|
    ProductOptionGroup.select{ |a| a.product && a.product.country == Country.th && a.options.count != 0 }.sample.options.each do |option|
      new_option = option.dup
      new_option.update!(product: option_group.product)
      option_group << new_option
    end
  end
end