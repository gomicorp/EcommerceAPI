# == Schema Information
#
# Table name: promotion_events
#
#  id               :bigint           not null, primary key
#  background_color :string(255)      default("#333333"), not null
#  expired_at       :datetime         not null
#  href             :string(255)      default("")
#  published_at     :datetime         not null
#  title            :string(255)      not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  country_id       :bigint           not null
#
# Indexes
#
#  index_promotion_events_on_country_id  (country_id)
#
# Foreign Keys
#
#  fk_rails_...  (country_id => countries.id)
#
class PromotionEvent < NationRecord
  extend_has_one_attached :thumbnail
  extend_has_one_attached :banner_pc
  extend_has_one_attached :banner_mb

  has_many :event_section_connections, class_name: 'Store::SectionConnection'
  has_many :event_sections, class_name: 'Store::Section', through: :event_section_connections, dependent: :destroy

  has_many :sections, class_name: 'Store::Section', as: :attachable

  scope :active, ->(standard_time = Time.zone.now) { where('published_at < :now AND expired_at > :now', now: standard_time) }
end
