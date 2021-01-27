# == Schema Information
#
# Table name: external_channel_cart_items
#
#  id                :bigint           not null, primary key
#  option_count      :integer          not null
#  unit_price        :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  country_id        :bigint
#  order_info_id     :bigint
#  product_option_id :bigint
#
# Indexes
#
#  ec_cart_items_on_ec_order_info_id                       (order_info_id)
#  index_external_channel_cart_items_on_country_id         (country_id)
#  index_external_channel_cart_items_on_product_option_id  (product_option_id)
#  order_info_product_option                               (order_info_id,product_option_id)
#
# Foreign Keys
#
#  fk_rails_...  (country_id => countries.id)
#  fk_rails_...  (order_info_id => external_channel_order_infos.id)
#
module ExternalChannel
  class CartItem < NationRecord
    belongs_to :product_option, class_name: 'ProductOption'
    belongs_to :order_info, class_name: 'ExternalChannel::OrderInfo'
  end
end

