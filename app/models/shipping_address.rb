# == Schema Information
#
# Table name: shipping_addresses
#
#  id           :bigint           not null, primary key
#  loc_state    :string(255)
#  loc_city     :string(255)
#  loc_district :string(255)
#  loc_detail   :text(65535)
#  postal_code  :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class ShippingAddress < ApplicationRecord
  has_many :user_addresses, class_name: 'UserShippingAddress', dependent: :destroy
  has_many :users, through: :user_addresses
end
