cart_item = item_sold_paper.item

json.item_sold_paper do
  json.cancelled item_sold_paper.cancelled?
  json.default_info item_sold_paper
  json.item do
    json.default_info cart_item
    json.product cart_item.product.title
    json.product_option cart_item.product_option.name
  end
end