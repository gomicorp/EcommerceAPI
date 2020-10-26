# == Schema Information
#
# Table name: external_channel_cart_items
#
#  id                 :bigint           not null, primary key
#  option_count       :integer          not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  external_option_id :string(255)      not null
#
class ExternalChannelCartItem < ApplicationRecord
  has_one :product_option, class_name: 'ProductOption'
end
