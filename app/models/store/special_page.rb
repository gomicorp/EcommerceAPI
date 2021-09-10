module Store
  class SpecialPage < NationRecord
    has_many :side_menu_items, class_name: 'Store::SideMenuItem', as: :pageable

    validates :title, presence: true
    # validates :slug, presence: true

    scope :active, ->(standard_time = Time.zone.now) { where('published_at < :now', now: standard_time) }
    scope :inactive, ->(standard_time = Time.zone.now) { where('published_at >= :now', now: standard_time).or(where(published_at: nil)) }

    def active?
      !published_at.nil? && published_at < Time.zone.now
    end
  end
end
