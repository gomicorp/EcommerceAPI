json.array! @item_sold_papers do |paper|
  json.partial! 'sellers/users/item_sold_papers/item_sold_paper', item_sold_paper: paper
end
