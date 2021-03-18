class CreatePromotionEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :promotion_events do |t|
      t.string :name
      t.datetime :published_at
      t.datetime :expired_at

      t.timestamps
    end
  end
end
