class AddColumnToSellersSellerInfoForCumulativeAmount < ActiveRecord::Migration[6.0]
  def change
    add_column :sellers_seller_infos, :cumulative_amount, :integer, null: false, default: 0
  end
end
