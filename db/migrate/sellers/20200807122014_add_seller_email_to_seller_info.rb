class AddSellerEmailToSellerInfo < ActiveRecord::Migration[6.0]
  def change
    add_column :sellers_seller_infos, :seller_email, :string
  end
end
