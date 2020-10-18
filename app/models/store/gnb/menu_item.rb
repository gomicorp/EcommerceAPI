# == Schema Information
#
# Table name: store_gnb_menu_items
#
#  id           :bigint           not null, primary key
#  active       :boolean          default(FALSE), not null
#  href         :string(255)      default("#"), not null
#  name         :text(65535)
#  published_at :datetime
#  sort_key     :integer          default(0), not null
#  view_port    :integer          default("desktop"), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  country_id   :bigint           not null
#
# Indexes
#
#  index_store_gnb_menu_items_on_country_id  (country_id)
#
# Foreign Keys
#
#  fk_rails_...  (country_id => countries.id)
#
module Store
  module Gnb
    class MenuItem < NationRecord
      include Translatable
      VIEW_PORTS = %i[desktop mobile].freeze
      enum view_port: VIEW_PORTS

      translate_column :name

      validates_presence_of :name, :href, :view_port, :sort_key
    end
  end
end
