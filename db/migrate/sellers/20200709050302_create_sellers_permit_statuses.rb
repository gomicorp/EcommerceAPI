class CreateSellersPermitStatuses < ActiveRecord::Migration[6.0]
  def change
    create_table :sellers_permit_statuses do |t|
      t.string :status

      t.timestamps
    end
  end
end
