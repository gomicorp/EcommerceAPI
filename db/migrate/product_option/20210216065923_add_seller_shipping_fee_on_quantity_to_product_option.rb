class AddSellerShippingFeeOnQuantityToProductOption < ActiveRecord::Migration[6.0]
  def change
    # seller_ship_fee_per_quantity : 판매자 창고 배송비의 수량연동 여부
    add_column :product_options, :seller_shipping_fee_per_quantity, :boolean, null: false, default: false
  end
end
