# == Schema Information
#
# Table name: store_sections
#
#  id                   :bigint           not null, primary key
#  background_color     :string(255)      default("#ffffff"), not null
#  connection_col_count :integer          default(4), not null
#  connection_limit     :integer          default(30), not null
#  connection_row_count :integer          default(2), not null
#  connection_type      :integer          default("no"), not null
#  expire_at            :datetime
#  href                 :string(255)
#  margin_bottom        :boolean          default(TRUE), not null
#  margin_top           :boolean          default(TRUE), not null
#  padding_bottom       :boolean          default(TRUE), not null
#  padding_top          :boolean          default(TRUE), not null
#  publish_at           :datetime
#  sord                 :integer          default(0), not null
#  title                :string(255)      default(""), not null
#  use_title            :boolean          default(TRUE), not null
#  view_port            :integer          default("desktop"), not null
#  wide_mode            :boolean          default(FALSE), not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  country_id           :bigint
#
# Indexes
#
#  index_store_sections_on_country_id  (country_id)
#
# Foreign Keys
#
#  fk_rails_...  (country_id => countries.id)
#
module Store
  class Section < NationRecord
    CONNECTION_TYPES = %i[no product_page-card-large product_page-card-compact].freeze
    VIEW_PORTS = %i[desktop mobile].freeze
    enum connection_type: CONNECTION_TYPES
    enum view_port: VIEW_PORTS

    has_many :connections, class_name: 'Store::SectionConnection', foreign_key: :store_section_id

    validates :publish_at, presence: true
    validates :expire_at, presence: true

    scope :active, -> { where('publish_at < :now AND expire_at > :now', now: Time.zone.now).sord }
    scope :prepared, -> { where('expire_at > :now AND expire_at >= publish_at', now: Time.zone.now).sord }
    scope :sord, -> { order(sord: :asc) }

    before_save :before_save_propagation


    private

    def before_save_propagation
      self.class.prepared.where(sord: sord).where.not(id: id.to_i).tap do |original_positioned|
        original_positioned.each { |section| section.update(sord: sord + 1) }
      end
    end
  end
end
