target_option_groups = ProductOptionGroup.select{|a| a.options.count == 0}
sample_option_groups = ProductOptionGroup.select{ |a| a.product && a.product.country == Country.th && a.options.count != 0 }

ApplicationRecord.transaction do
  target_option_groups.each do |option_group|
    sample_option_groups.sample.options.each do |option|
      new_option = option.dup
      new_option.update!(product: option_group.product)
      option_group.options << new_option
    end
  end
end