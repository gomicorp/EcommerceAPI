cart_items = @item_sold_papers.map(&:item)
json.sales_amount_sum cart_items.sum(&:captured_retail_price)
json.sales_profit_sum @item_sold_papers.sum(&:adjusted_profit)
