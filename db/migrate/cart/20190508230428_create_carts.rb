class CreateCarts < ActiveRecord::Migration[5.2]
  def change
    create_table :carts do |t|
      t.references :user, foreign_key: true
      t.integer :order_status
      t.datetime :ordered_at

      t.timestamps
    end
  end
end
