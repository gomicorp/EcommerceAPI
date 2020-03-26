class AddOptionCountToCartItem < ActiveRecord::Migration[6.0]
  def change
    add_column :cart_items, :option_count, :integer, null: false, default: 1
  end
end
