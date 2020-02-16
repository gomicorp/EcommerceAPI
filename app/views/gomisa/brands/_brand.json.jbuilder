json.except! brand
json.url gomisa_brand_url(brand, format: :json)

if brand.logo.attached?
  json.logo polymorphic_url(brand.logo)
else
  json.logo nil
end

#json.exports product_item.exports_quantity(params[:from], params[:to], params[:channel])
