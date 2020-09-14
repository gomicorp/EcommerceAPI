module HaravanProduct
  class GetHaravanProducts
    include HaravanApiHelper
    include HaravanApiHelper::HaravanProduct

    def initialize
      super
    end

    def new(*args)
    end

    def save_haravan_products(from, to)
      ActiveRecord::Base.transaction do
        begin
          haravan_products = get_product_by_period(from, to)
          haravan_products.each do |haravan_product|
            _parse_data(haravan_product)
            _save_product_page
            _save_product_options
            true
          end
        rescue => e
          ap e
          ActiveRecord::Rollback
        end
      end

    end


    private

    @title
    @variants
    @brand
    @product

    # parse haravan raw data to make the products and product options
    def _parse_data(haravan_product)
      @title = haravan_product["title"]
      @variants = haravan_product["variants"]
      @brand = Brand.where('name LIKE ?', "%#{haravan_product["vendor"]}%").first
    end

    # Product page saver
    def _save_product_page
      product_data = _make_product_data
      @product = Product.where('title LIKE ?', "%#{@title}%").first_or_initialize
      @product.assign_attributes(product_data)
      @product.assign_attributes(title: product_data["title"].to_h)
      @product.save!
    end

    # Save Product Options that reveal on product page.
    def _save_product_options
      product_option_group = @product.option_groups.first_or_create
      channel_id = Channel.find_by_name('haravan').id
      @variants.each do |option|
        product_option_params = _make_product_option_data(option, channel_id)
        product_option = product_option_group.options.build(product_option_params)
        product_option.save!
      end
    end

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
