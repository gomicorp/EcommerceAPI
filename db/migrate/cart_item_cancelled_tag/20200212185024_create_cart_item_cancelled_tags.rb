class CreateCartItemCancelledTags < ActiveRecord::Migration[6.0]
  def change
    create_table :cart_item_cancelled_tags do |t|
      t.references :cart_item, null: false, foreign_key: true
      t.datetime :cancelled_at

      t.timestamps
    end
  end
end
