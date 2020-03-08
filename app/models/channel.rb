class Channel < NationRecord
  has_many :order_infos
  has_many :product_options

  validates_uniqueness_of :name, scope: %i[country_id]
end
