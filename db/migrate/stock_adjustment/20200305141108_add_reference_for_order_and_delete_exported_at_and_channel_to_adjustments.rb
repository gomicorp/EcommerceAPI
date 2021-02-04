class AddReferenceForOrderAndDeleteExportedAtAndChannelToAdjustments < ActiveRecord::Migration[6.0]
  def change
    remove_column :adjustments, :exported_at, :datetime
    remove_column :adjustments, :channel, :string
    remove_column :adjustments, :order_id, :integer
    add_reference :adjustments, :order_info, references: :order_infos, index: true
  end
end
