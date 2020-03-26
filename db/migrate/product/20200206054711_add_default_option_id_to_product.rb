class AddDefaultOptionIdToProduct < ActiveRecord::Migration[6.0]
  def change
    add_reference :products, :default_option, foreign_key: { to_table: :product_options }
  end
end
