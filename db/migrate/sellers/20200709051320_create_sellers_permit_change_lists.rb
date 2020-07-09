class CreateSellersPermitChangeLists < ActiveRecord::Migration[6.0]
  def change
    create_table :sellers_permit_change_lists do |t|
      t.references :sellers_seller_info, null: false, foreign_key: true
      t.references :sellers_permit_status, null: false, foreign_key: true
      t.text :reason

      t.timestamps
    end
  end
end
