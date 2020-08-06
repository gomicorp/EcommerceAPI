json.seller do
  json.default_info seller
  json.interest_tags seller.interest_tags
  json.partial! 'sellers/users/seller_infos/seller_info', seller_info: seller.seller_info
end
