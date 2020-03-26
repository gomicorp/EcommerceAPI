module Banner
  class Base < NationRecord
    self.table_name = :banners
    enum banner_type: %i[home category]
    extend_has_one_attached :image

    scope :active, -> { where(active: true) }
  end
end
