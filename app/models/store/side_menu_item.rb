module Store
  class SideMenuItem < ApplicationRecord
    extend_has_one_attached :connected_banner_image

    belongs_to :pageable, polymorphic: true     # => SpecialPage
    belongs_to :connectable, polymorphic: true, optional: true  # => Brand | Category

    validates :name, presence: true

    scope :ordered, -> { order(sort_key: :asc) }
  end
end
