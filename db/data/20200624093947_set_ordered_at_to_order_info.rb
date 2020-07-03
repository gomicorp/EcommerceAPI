class SetOrderedAtToOrderInfo < ActiveRecord::Migration[6.0]
  def up
    ApplicationRecord.country_context_with 'global' do
      OrderInfo.update_all('ordered_at=created_at')
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
