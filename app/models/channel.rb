class Channel < NationRecord
  has_many :order_infos
  has_many :product_options

  validates_uniqueness_of :name, scope: %i[country_id]

  def self.default_channel
    @default_channel ||= find_or_create_by(name: 'Gomi')
  end

  def self.externals
    where.not(id: default_channel.id)
  end
end
