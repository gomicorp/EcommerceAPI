module ExternalChannel
  class OrderInfo < NationRecord
    has_not_paper_trail

    has_many :external_channel_order_info_brands, class_name: 'ExternalChannel::OrderInfoBrand', dependent: :destroy
    has_many :brands, class_name: 'Brand', through: :external_channel_order_info_brands
    has_many :external_channel_cart_items, class_name: 'ExternalChannel::CartItem', dependent: :destroy
    has_many :product_options, through: :external_channel_cart_items
    has_many :product_pages, through: :product_options

    zombie :product_options
  end
end
