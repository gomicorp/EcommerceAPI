# == Schema Information
#
# Table name: channels
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  country_id :bigint
#
# Indexes
#
#  index_channels_on_country_id  (country_id)
#
# Foreign Keys
#
#  fk_rails_...  (country_id => countries.id)
#
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
