class RenameOrderInfoExpiredAtToDiscardedAt < ActiveRecord::Migration[6.0]
  def up
    rename_column :order_infos, :expired_at, :discarded_at
  end

  def down
    rename_column :order_infos, :discarded_at, :expired_at
  end
end
