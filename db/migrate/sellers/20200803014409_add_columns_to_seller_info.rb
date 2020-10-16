class AddColumnsToSellerInfo < ActiveRecord::Migration[6.0]
  def change
    add_column :sellers_seller_infos, :sns_name, :string
    add_column :sellers_seller_infos, :sns_id, :string
    add_column :sellers_seller_infos, :purpose, :text
  end
end
