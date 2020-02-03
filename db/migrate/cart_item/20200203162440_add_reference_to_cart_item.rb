class AddReferenceToCartItem < ActiveRecord::Migration[6.0]
  def change
    add_reference :cart_items, :product_option, index: true, null: false, default: 0
  end
end
