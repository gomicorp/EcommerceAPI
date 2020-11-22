# == Schema Information
#
# Table name: external_channel_cart_items
#
#  id                 :bigint           not null, primary key
#  option_count       :integer          not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  country_id         :bigint
#  external_option_id :string(255)      not null
#
# Indexes
#
#  index_external_channel_cart_items_on_country_id  (country_id)
#
# Foreign Keys
#
#  fk_rails_...  (country_id => countries.id)
#
class ExternalChannelCartItem < NationRecord
  has_one :product_option, class_name: 'ProductOption'
  belongs_to :external_channel_order_info, class_name: 'ExternalChannelOrderInfo', dependent: :destroy
end
