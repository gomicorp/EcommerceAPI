module ExternalChannel
  class CartItem < NationRecord
    belongs_to :product_option, class_name: 'ProductOption'
    belongs_to :order_info, class_name: 'ExternalChannel::OrderInfo'
  end
end

