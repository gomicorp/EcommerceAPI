class RemoveExternalOptionIdInEcCartItem < ActiveRecord::Migration[6.0]
  def change
    remove_column :external_channel_cart_items, :external_option_id
  end
end
