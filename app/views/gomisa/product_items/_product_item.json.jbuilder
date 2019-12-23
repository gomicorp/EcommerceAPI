json.except! product_item
json.quantity product_item.exports_quantity(params[:from], params[:to], params[:channel])
json.brand product_item.item_group.brand 
