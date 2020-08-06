# = 데이터가 없을 경우를 대비해서 빈 인스턴스를 넣어줍니다
interest_tags = seller.interest_tags || InterestTag.new
seller_info = seller.seller_info || Sellers::SellerInfo.new

json.seller do
  json.default_info seller
  json.interest_tags interest_tags
  json.partial! 'sellers/users/seller_infos/seller_info', seller_info: seller_info
end
