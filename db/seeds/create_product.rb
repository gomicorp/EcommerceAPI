require 'open-uri'
Faker::Config.locale = 'en'

ApplicationRecord.transaction do
    product = Product.new(title: { ko: Faker::Book.title, en: Faker::Book.title, th: Faker::Book.title })
    options = ProductOptionGroup.all.select{ |a| a.options.count != 0 }.sample.options
    product.brand = Brand.all.sample
    product.country = Country.th
    product.categories << Category.all.sample
    product.running_status = 3
    product.default_option = options.first
    product.save

    product.option_groups << ProductOptionGroup.new(product: product, options: options)
    download_image = open(Faker::Avatar.image)
    product.thumbnail.attach(io: download_image, filename: "thumb.png")

    ap product.id
end