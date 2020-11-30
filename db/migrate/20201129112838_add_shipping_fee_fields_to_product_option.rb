class AddShippingFeeFieldsToProductOption < ActiveRecord::Migration[6.0]
  def change
    # seller_shipping : 판매자 배송 여부
    # seller_warehouse_key : 판매자 창고 번호
    # seller_warehouse_ship_fee : 판매자 창고 배송비
    add_column :product_options, :seller_shipping, :boolean, null: false, default: false
    add_column :product_options, :seller_warehouse_key, :string
    add_column :product_options, :seller_warehouse_ship_fee, :integer
  end
end
