class AddColomnForOrderedToItemSoldPaper < ActiveRecord::Migration[6.0]
  def change
    add_column :sellers_item_sold_papers, :ordered, :boolean, default: false
  end
end
