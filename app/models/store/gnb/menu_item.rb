module Store
  module Gnb
    class MenuItem < NationRecord
      include Translatable
      VIEW_PORTS = %i[desktop mobile].freeze
      enum view_port: VIEW_PORTS

      translate_column :name

      validates_presence_of :name, :href, :view_port, :sort_key

      scope :ordered, -> { order(sort_key: :asc) }
      scope :active, -> { where(active: true) }
      scope :view_ports, ->(view_port = nil) { where(view_port: view_port || :desktop) }

      def new_badge
        published_at && (published_at >= 1.month.ago)
      end

      def publish!
        update(published_at: Time.zone.now, active: true)
      end
    end
  end
end
