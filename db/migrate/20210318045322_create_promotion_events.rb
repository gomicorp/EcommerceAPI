class CreatePromotionEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :promotion_events do |t|
      t.string :title, null: false
      t.string :background_color, null: false, default: '#333333'
      t.datetime :published_at, null: false
      t.datetime :expired_at, null: false

      t.timestamps
    end
  end
end
