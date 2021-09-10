module Store
  class SectionConnection < ApplicationRecord
    belongs_to :section, class_name: 'Store::Section', foreign_key: :store_section_id
    belongs_to :product_page, class_name: 'Product', optional: true, foreign_key: :product_id
  end
end
