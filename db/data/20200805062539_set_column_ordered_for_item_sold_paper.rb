class SetColumnOrderedForItemSoldPaper < ActiveRecord::Migration[6.0]
  def up
    Sellers::ItemSoldPaper.all.each do |paper|
      paper.update(ordered: !paper.item.order_info.nil?)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
