class CreateSellersPermitChangeLists < ActiveRecord::Migration[6.0]
  def change
    create_table :sellers_permit_change_lists do |t|
      t.references :seller_info, null: false, foreign_key: { to_table: :sellers_seller_infos }
      t.references :permit_status, null: false, foreign_key: { to_table: :sellers_permit_statuses }
      t.text :reason

      t.timestamps
    end
  end
end
