if @removed_product.length == 1
  json.removed_product @removed_product[0]
else
  json.removed_product @removed_product
end
