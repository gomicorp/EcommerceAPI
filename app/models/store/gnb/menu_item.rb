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
#
module Store
  module Gnb
    class MenuItem < ApplicationRecord
      include Translatable
      enum view_port: %i[desktop mobile]

      translate_column :name

      validates_presence_of :name, :href, :view_port, :sort_key
    end
  end
end
