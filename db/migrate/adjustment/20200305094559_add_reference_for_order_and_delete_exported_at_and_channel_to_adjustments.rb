class AddReferenceForOrderAndDeleteExportedAtAndChannelToAdjustments < ActiveRecord::Migration[6.0]
  def change
    remove_column :adjustments, :exported_at
    remove_column :adjustments, :channel
    remove_column :adjustments, :order_id
    add_reference :adjustments, :order, references: :orders, index: true
  end
end
