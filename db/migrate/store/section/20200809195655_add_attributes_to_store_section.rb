class AddAttributesToStoreSection < ActiveRecord::Migration[6.0]
  def change
    add_column :store_sections, :padding_top, :boolean, null: false, default: true
    add_column :store_sections, :padding_bottom, :boolean, null: false, default: true

    add_column :store_sections, :publish_at, :datetime
    add_column :store_sections, :expire_at, :datetime
  end
end
