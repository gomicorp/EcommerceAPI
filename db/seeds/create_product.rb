require 'open-uri'
Faker::Config.locale = 'en'

ApplicationRecord.transaction do
  options = ProductOptionGroup.all.select{ |a| a.product && a.product.country == Country.th && a.options.count != 0 }

  500.times do
    title = Faker::Book.title
    product = Product.new(title: { ko: title, en: title, th: title })
    cur_options = options.sample.options

    brand = Brand.all.sample
    product.brand = brand

    product.country = Country.th

    product.running_status = 3
    product.default_option = cur_options.first
    product.save!

    product.option_groups << ProductOptionGroup.new(product: product, options: cur_options)

    category = Category.all.sample
    product.categories << category

    download_image = open(Faker::Avatar.image)
    product.thumbnail.attach(io: download_image, filename: "thumb.png")
  end
end