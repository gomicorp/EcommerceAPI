module Store
  class PromotionEvent < NationRecord
    extend FriendlyId
    extend_has_one_attached :thumbnail
    extend_has_one_attached :banner_pc
    extend_has_one_attached :banner_mb
    friendly_id :title, use: %i[slugged finders history]

    has_many :event_section_connections, class_name: 'Store::SectionConnection'
    has_many :event_sections, class_name: 'Store::Section', through: :event_section_connections, dependent: :destroy

    has_many :sections, class_name: 'Store::Section', as: :attachable

    scope :active, ->(standard_time = Time.zone.now) { where('published_at < :now AND expired_at > :now', now: standard_time) }
  end
end
