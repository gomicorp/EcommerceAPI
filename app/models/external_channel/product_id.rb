# == Schema Information
#
# Table name: external_channel_product_ids
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  channel_id  :bigint           not null
#  country_id  :bigint
#  external_id :string(255)      not null
#  product_id  :bigint           not null
#
# Indexes
#
#  index_external_channel_product_ids_on_channel_id  (channel_id)
#  index_external_channel_product_ids_on_country_id  (country_id)
#  index_external_channel_product_ids_on_product_id  (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (country_id => countries.id)
#
module ExternalChannel
  class ProductId < NationRecord
    belongs_to :product, dependent: :destroy
    belongs_to :channel, dependent: :destroy
  end
end
