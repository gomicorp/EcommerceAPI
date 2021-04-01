class RenameTablePromotionEventToStorePromotionEvent < ActiveRecord::Migration[6.0]
  def change
    rename_table :promotion_events, :store_promotion_events
  end
end
