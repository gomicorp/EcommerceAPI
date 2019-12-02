class AddCancelledAtToBarcode < ActiveRecord::Migration[5.2]
  def change
    add_column :barcodes, :cancelled_at, :datetime
  end
end
