class ChangeSnsTypeInSellerInfo < ActiveRecord::Migration[6.0]
  def change
    remove_column :sellers_seller_infos, :sns_name, :string
    add_reference :sellers_seller_infos, :social_media_service, foreign_key: true
  end
end
