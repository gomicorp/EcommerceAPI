class ChangeSnsTypeInSellerInfo < ActiveRecord::Migration[6.0]
  def change
    remove_column :sellers_seller_infos, :sns_name
    add_reference :sellers_seller_infos, :social_media_service
  end
end
