# == Schema Information
#
# Table name: promotion_events
#
#  id           :bigint           not null, primary key
#  expired_at   :datetime
#  name         :string(255)
#  published_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class PromotionEvent < ApplicationRecord
  extend_has_one_attached :thumbnail
  extend_has_one_attached :banner

  has_many :event_section_connections, class_name: 'Store::SectionConnection'
  has_many :event_sections, class_name: 'Store::Section', through: :event_section_connections, dependent: :destroy

  has_many :sections, class_name: 'Store::Section', as: :attachable

  scope :active, ->(standard_time = Time.zone.now) { where('published_at < :now AND expired_at > :now', now: standard_time) }
end
