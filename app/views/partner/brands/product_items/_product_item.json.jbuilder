#
# Helpers
#

# has_one_attached file
image_url_or_nil = proc do |resource, method|
  attachment = resource.send(method)

  if attachment.attached?
    {
        filename: attachment.filename,
        url: rails_blob_url(attachment),
        attachment_id: attachment.id,
    }
  end
end

# has_many_attached file
data_for_attachments = proc do |attachment|
  json.filename attachment.filename
  json.url rails_blob_url(attachment)
  json.attachment_id attachment.id
end


#
# Content Body
#

json.except! product_item

json.cfs image_url_or_nil.call(product_item, :cfs)
json.msds image_url_or_nil.call(product_item, :msds)
json.ingredient_table image_url_or_nil.call(product_item, :ingredient_table)
json.box_images(product_item.box_images, &data_for_attachments)
json.images(product_item.images, &data_for_attachments)

json.url partner_brand_product_item_url(@brand, product_item, format: :json)

json.product_item_group do
  group = product_item.item_group
  json.except! group
  json.url partner_brand_product_item_group_url(@brand, group, format: :json)
end

json.brand do
  json.except! @brand
  json.url partner_brand_url(@brand, format: :json)
end
