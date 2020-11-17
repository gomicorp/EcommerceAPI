class SetItemSoldPaper < ActiveRecord::Migration[6.0]
  def up
    Sellers::OrderSoldPaper.all.each do |paper|
      order = paper.order_info
      seller_info = paper.seller_info
      order.items.each do |item|
        Sellers::ItemSoldPaper.create(
          item: item,
          seller_info: seller_info,
          adjusted_profit: (item.result_price * item.option_count * seller_info.commission_rate)
          )
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
