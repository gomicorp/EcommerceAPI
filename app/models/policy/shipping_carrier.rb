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
class Policy::ShippingCarrier < NationRecord
  belongs_to :country

  scope :trackable, -> { where(trackable: true) }

  def self.code_list
    pluck(:code)
  end

  def self.list
    pluck(:name)
  end
end
