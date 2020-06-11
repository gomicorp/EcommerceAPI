class SetOrderInfoBrands < ActiveRecord::Migration[6.0]
  def up
    ApplicationRecord.country_context_with 'global' do
      OrderInfo.all.each do |order_info|
        order_info.product_options.each do |option|
          option.bridges.each do |bridge|
            bridge.brands.each do |brand|
              OrderInfoBrand.create(order_info: order_info, brand: brand)
            end
          end
        end

        # 정상적인 로직으로 데이터를 채워줄 수 없는 레거시 데이터에 대한 대응
        order_info.items.each do |item|
          item.barcodes.each do |barcode|
            OrderInfoBrand.create(order_info: order_info, brand: barcode.product.brand)
          end
        end
      end
    end
  end

  def down
    # raise ActiveRecord::IrreversibleMigration if Rails.production?
  end
end
