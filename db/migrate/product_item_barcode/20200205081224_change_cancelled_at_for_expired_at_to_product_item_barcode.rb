class ChangeCancelledAtForExpiredAtToProductItemBarcode < ActiveRecord::Migration[6.0]
  def change
    rename_column :product_item_barcodes, :cancelled_at, :expired_at
  end
end
