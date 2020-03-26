class AddAliveBarcodesCountToProductItem < ActiveRecord::Migration[6.0]
  def change
    add_column :product_items, :alive_barcodes_count, :integer, null: false, default: 0
  end
end
