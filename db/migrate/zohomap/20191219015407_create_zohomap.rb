class CreateZohomap < ActiveRecord::Migration[6.0]
  def change
    create_table :zohomaps do |t|
      t.string  :zoho_id
      t.bigint  :zohoable_id
      t.string  :zohoable_type
      t.timestamps
    end
  end
end
