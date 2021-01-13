class CreateStoreSideMenuItems < ActiveRecord::Migration[6.0]
  def change
    create_table :store_side_menu_items do |t|
      # 이 메뉴가 어떤 형태의 페이지에 붙어있을 수 있는지 관계를 정의합니다.
      t.references :pageable, polymorphic: true, index: { name: 'side_menu_pageable_idx' }

      # 브랜드나 카테고리 등 다양한 모델을 이 아이템과 연결합니다.
      t.references :connectable, polymorphic: true, index: { name: 'side_menu_connectable_idx' }

      t.integer :sort_key, null: false, default: 0

      t.timestamps
    end
  end
end
