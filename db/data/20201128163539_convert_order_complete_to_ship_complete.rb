class ConvertOrderCompleteToShipComplete < ActiveRecord::Migration[6.0]
  def up
    ApplicationRecord.country_context_with 'global' do
      OrderInfo.global.where(status: :order_complete).update_all(status: :ship_complete)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
