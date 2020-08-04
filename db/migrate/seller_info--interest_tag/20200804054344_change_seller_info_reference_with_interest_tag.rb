class ChangeSellerInfoReferenceWithInterestTag < ActiveRecord::Migration[6.0]
  def change
    rename_column :seller_info_interest_tags, :sellers_seller_info_id, :seller_info_id
  end
end
