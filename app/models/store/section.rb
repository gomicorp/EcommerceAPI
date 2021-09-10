module Store
  class Section < NationRecord
    CONNECTION_TYPES = %i[no product_page-card-large product_page-card-compact].freeze
    VIEW_PORTS = %i[desktop mobile].freeze
    enum connection_type: CONNECTION_TYPES
    enum view_port: VIEW_PORTS

    belongs_to :attachable, polymorphic: true, optional: true
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
