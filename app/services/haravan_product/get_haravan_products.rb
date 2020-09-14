module HaravanProduct
  class GetHaravanProducts
    include HaravanApiHelper
    include HaravanApiHelper::HaravanProduct

    # == 상품 불러오기 및 저장
    def save_haravan_products(from, to)
      ActiveRecord::Base.transaction do
        begin
          haravan_products = get_product_by_period(from, to)
          haravan_products.each do |haravan_product|
            extract_data(haravan_product)
            save_product
            save_product_options
          end
        rescue => e
          ap e
          ActiveRecord::Rollback
        end
      end

    end

    private

    @id
    @title
    @variants
    @brand
    @product

    # == 데이터 추출
    # parse haravan raw data to make the products and product options
    def extract_data(haravan_product)
      @id = haravan_product["id"]
      @title = haravan_product["title"]
      @variants = haravan_product["variants"]
      @brand = Brand.where("JSON_EXTRACT(name, '$.vi') LIKE ?", "\"#{haravan_product["vendor"]}\"").first
    end

    # == 상품페이지를 저장
    # Product page saver
    def save_product
      @product = Product.find_or_initialize_by(haravan_id: @id)
      @product.assign_attributes(brand_id: @brand.id,
                                 running_status: 'pending',
                                 title: {'vn': @title, 'en': @title, 'ko': @title})
      # @product.assign_attributes(title: product_data["title"].to_h)
      @product.save!
    end

    # == 상품 옵션을 저장
    # Save Product Options that reveal on product page.
    def save_product_options
      product_option_group = @product.option_groups.first_or_create
      channel_id = Channel.find_by_name('haravan').id
      @variants.each do |option|
        product_option = ProductOption.find_by(channel_code: option[:id])
        if product_option
          product_option.update!(name: product_option[:title])
        else
          product_option_group.options.build(name: product_option[:title],
                                             channel_id: channel_id,
                                             channel_code: option[:id])
        end
      end
    end

    # == 데이터 포장
    def _make_product_data
      {
        :brand_id => @brand.id,
        :price => @variants[0][:price],
        :running_status => 'pending',
        :title => {'vn': @title, 'en': @title, 'ko': @title},
        :catalogs => [],
        :images => []
      }
    end

    # == 데이터 포장
    def _make_product_option_data(product_option, channel_id)
      {
        name: product_option[:title],
        "additional_price" => "0",
        "discount_type" => "no",
        "discount_amount"=> "0.0",
        "channel_id": channel_id,
        "channel_code": product_option[:id]
      }
    end
  end
end
