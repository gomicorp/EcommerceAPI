class RemoveSellersOrderSoldPaper < ActiveRecord::Migration[6.0]
  def change
    drop_table :sellers_order_sold_papers
  end
end
