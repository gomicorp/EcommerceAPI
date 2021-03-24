class CreatePromotionEvents < ActiveRecord::Migration[6.0]
  def up
    create_table :promotion_events do |t|
      t.string :title, null: false
      t.string :background_color, null: false, default: '#333333'
      t.string :href, default: ''
      t.datetime :published_at, null: false
      t.datetime :expired_at, null: false
      t.references :country, foreign_key: true, null: false

      t.timestamps
    end
  end

  def down
    drop_table :promotion_events
  end
end
