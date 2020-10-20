# == Schema Information
#
# Table name: store_side_menu_items
#
#  id               :bigint           not null, primary key
#  connectable_type :string(255)
#  name             :string(255)
#  pageable_type    :string(255)
#  sort_key         :integer          default(0), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  connectable_id   :bigint
#  pageable_id      :bigint
#
# Indexes
#
#  side_menu_connectable_idx  (connectable_type,connectable_id)
#  side_menu_pageable_idx     (pageable_type,pageable_id)
#
module Store
  class SideMenuItem < ApplicationRecord
    belongs_to :pageable, polymorphic: true
    belongs_to :connectable, polymorphic: true
  end
end
