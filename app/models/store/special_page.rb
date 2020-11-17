# == Schema Information
#
# Table name: store_special_pages
#
#  id           :bigint           not null, primary key
#  published_at :datetime
#  slug         :string(255)
#  title        :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  country_id   :bigint           not null
#
# Indexes
#
#  index_store_special_pages_on_country_id  (country_id)
#
# Foreign Keys
#
#  fk_rails_...  (country_id => countries.id)
#
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
