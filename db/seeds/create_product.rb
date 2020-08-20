ApplicationRecord.transaction do
    product = Product.new(title: { ko: Faker::Book.title, en: Faker::Book.title, th: Faker::Book.title })
    options = ProductOptionGroup.all.sample.options
    product.brand = Brand.all.sample
    product.country = Country.th
    product.categories << Category.all.sample
    product.running_status = 3
    product.default_option = options.first
    product.save

    product.option_groups << ProductOptionGroup.new(product: product, options: options)
    product.thumbnail = Faker::Avatar.image
    ap product
    ap product.options
end