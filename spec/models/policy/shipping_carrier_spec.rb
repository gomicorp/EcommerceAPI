# == Schema Information
#
# Table name: policy_shipping_carriers
#
#  id         :bigint           not null, primary key
#  code       :string(255)      not null
#  name       :string(255)      not null
#  trackable  :boolean
#  url        :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  country_id :bigint           not null
#
# Indexes
#
#  index_policy_shipping_carriers_on_code        (code) UNIQUE
#  index_policy_shipping_carriers_on_country_id  (country_id)
#
require 'rails_helper'

RSpec.describe Policy::ShippingCarrier, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
