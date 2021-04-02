class AddSlugToPromotionEvent < ActiveRecord::Migration[6.0]
  def change
    add_column :store_promotion_events, :slug, :string
    add_index :store_promotion_events, :slug, unique: true
  end
end
