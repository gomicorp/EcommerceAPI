json.except! product_attribute

json.option_names do
  option_names = ""
  product_attribute.options.each do |option|
    option_names += option.name + ", "
  end

  if option_names != ""
    option_names = option_names[0..-2]
  end
  json.except! option_names
end
