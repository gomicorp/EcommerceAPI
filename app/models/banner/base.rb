module Banner
  class Base < ApplicationRecord
    self.table_name = :banners
    enum banner_type: %i[home category]

    scope :active, -> { where(active: true) }
  end
end
