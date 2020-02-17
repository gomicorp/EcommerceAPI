json.product_item_group do
  json.except! product_item_group
end

#json.product_attribute do
#  json.array! product_item_group.product_attributes,json_partial!: 'gomisa/product_attributes/product_attribute', as: :attribute
#end

json.product_attribute product_item_group.product_attributes.each do |attribute|
  json.except! attribute

  option_names = ""
  attribute.options.each do |option|
    option_names += option.name + ", "
  end

  if option_names != ""
    option_names = option_names[0..-3]
  end
  json.option_names option_names
end

json.product_item do
  json.array! product_item_group.items, partial: "gomisa/product_item_groups/items/item", as: :product_item
end
