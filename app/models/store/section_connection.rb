# == Schema Information
#
# Table name: store_section_connections
#
#  id               :bigint           not null, primary key
#  background_color :string(255)      default("#ffffff"), not null
#  href             :string(255)
#  sord             :integer          default(0), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  product_id       :bigint
#  store_section_id :bigint           not null
#
# Indexes
#
#  index_store_section_connections_on_product_id        (product_id)
#  index_store_section_connections_on_store_section_id  (store_section_id)
#
# Foreign Keys
#
#  fk_rails_...  (store_section_id => store_sections.id)
#
module Store
  class SectionConnection < ApplicationRecord
    belongs_to :section, class_name: 'Store::Section', foreign_key: :store_section_id
    belongs_to :product_page, class_name: 'Product', optional: true, foreign_key: :product_id
  end
end
