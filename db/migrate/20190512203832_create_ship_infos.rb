class CreateShipInfos < ActiveRecord::Migration[5.2]
  def change
    create_table :ship_infos do |t|
      t.integer :order_info_id

      t.string :receiver_name
      t.string :receiver_tel
      t.string :receiver_email

      # This should be extract another table such as 'locations'.
      t.string :loc_state
      t.string :loc_city
      t.string :loc_district
      t.string :loc_detail

      t.integer :ship_type, null: false, default: 0
      t.integer :ship_amount, null: false, default: 0

      t.string :user_memo

      t.timestamps
    end
  end
end
