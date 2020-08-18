# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


#=== social media services ===#
ApplicationRecord.transaction do
  SocialMediaService.find_or_create_by(name: "facebook")
  SocialMediaService.find_or_create_by(name: "instagram")
  SocialMediaService.find_or_create_by(name: "youtube")
  SocialMediaService.find_or_create_by(name: "blog")
end

#=== bank ===#
ApplicationRecord.transaction do
  Bank.find_or_create_by(name: 'kakao', country: Country.ko)
  Bank.find_or_create_by(name: 'kb', country: Country.ko)
  Bank.find_or_create_by(name: 'shinhan', country: Country.ko)
  Bank.find_or_create_by(name: 'woori', country: Country.ko)

  Bank.find_or_create_by(name: 'agri', country: Country.vn)
  Bank.find_or_create_by(name: 'vietcom', country: Country.vn)
  Bank.find_or_create_by(name: 'vp', country: Country.vn)
  Bank.find_or_create_by(name: 'sacom', country: Country.vn)

  Bank.find_or_create_by(name: 'bangkok', country: Country.th)
  Bank.find_or_create_by(name: 'krung thai', country: Country.th)
  Bank.find_or_create_by(name: 'kasikorn', country: Country.th)
  Bank.find_or_create_by(name: 'siam commercial', country: Country.th)
end

#=== interest tag ===#
ApplicationRecord.transaction do
  InterestTag.find_or_create_by(name: 'fashion', created_by: 'gomi')
  InterestTag.find_or_create_by(name: 'food', created_by: 'gomi')
  InterestTag.find_or_create_by(name: 'life', created_by: 'gomi')
  InterestTag.find_or_create_by(name: 'kitchen', created_by: 'gomi')
  InterestTag.find_or_create_by(name: 'sports', created_by: 'gomi')
  InterestTag.find_or_create_by(name: 'pets', created_by: 'gomi')
  InterestTag.find_or_create_by(name: 'electronics', created_by: 'gomi')
end

# seller_tester_emails = %w[tobepygrammer titiwood@nate.com ywsis@daum.net dltmdcks702@naver.com]
#
# sellers = seller_tester_emails.map do |tester_mail|
#   tester = User.where('email like ?', "%#{tester_mail}%").first
#   next if tester.nil?
#
#   tester.update!(is_seller: true)
#   Seller.find(tester.id)
# end.compact
#
# #=== sellers seller info ===#
# #=== sellers store info ===#
# #=== sellers account info ===#
# def seller_info_seed_breeder(seller, store, account)
#   {
#     seller: seller,
#     store_info: store,
#     account_infos: [account],
#     grade: Sellers::Grade.beginner,
#     sns_id: seller.email.split('@').first
#   }
# end
#
# sellers.select { |s| s.seller_info.nil? }.each do |seller|
#   ApplicationRecord.transaction do
#     seller_info = Sellers::SellerInfo.create!(seller: seller, grade: Sellers::Grade.beginner, social_media_service: SocialMediaService.first)
#     store = Sellers::StoreInfo.create!(
#       seller_info: seller_info,
#       name: 'pop S2 up sotre for' << seller.name,
#       comment: 'Here is test store'
#     )
#     store.update!(
#       url: 'https://gomistore.in.th/popup_store/' << store.id.to_s,
#     )
#     ap 'store info is created'
#     ap store
#
#     account = Sellers::AccountInfo.create!(
#       seller_info: seller_info,
#       bank: Bank.all.sample,
#       account_number: Random.rand(1.0).to_s.slice(2..14),
#       owner_name: seller.name
#     )
#     ap 'account info is created'
#     ap account.save!
#
#     seller_info.update!(seller_info_seed_breeder(seller, store, account))
#     ap 'seller info is created'
#     ap seller_info
#   end
# end
#
# ApplicationRecord.transaction do
#   #=== permit_change_list ===#
#   sellers.each do |seller|
#     seller_info = seller.seller_info
#     next if seller_info.permit_change_lists.any?
#
#     seller_info.permit_change_lists << Sellers::PermitChangeList.create(
#       permit_status: Sellers::PermitStatus.permitted
#     )
#     ap 'permitted'
#   end
# end
#
# #=== selected_product ===#
# #live_products => 판매중이고, 디폴트 옵션이 잔여 수량이 있는 상품
# live_products = Product.running.select do |product|
#   product.default_option && !product.default_option.available_quantity.zero?
# end
# # live_products중 두개를 셀러의 스토어에 연결
# ApplicationRecord.transaction do
#   sellers.map(&:seller_info).map(&:store_info).each do |seller_store|
#     next if seller_store.products.any?
#
#     linkable_products = live_products.sample(2)
#
#     Sellers::SelectedProduct.create!(store_info: seller_store, product: linkable_products.first)
#     Sellers::SelectedProduct.create!(store_info: seller_store, product: linkable_products.last)
#     ap 'product linked'
#     ap({store: seller_store.name, product: linkable_products})
#   end
# end

#=== order by seller store ===#
#=== item sold paper ===#
#ship_info_samples => 기존에 존재하는 가장 최근의 5개 ship info에서 reference와 timestamp를 제거, 샘플값으로 활용
ship_info_samples = OrderInfo.last(5).map(&:ship_info).map do |ship_info|
  ship_info.attributes.tap do |sample|
    sample.delete('id')
    sample.delete('order_info_id')
    sample.delete('created_at')
    sample.delete('updated_at')
    sample.update(ship_type: 'normal')
    sample
  end
end

# 주문이 가능한 유저데이터로, 스토어마다 주문을 5번 합니다.
# 5개의 주문 중 4개의 주문을 결제완료처리합니다.
ApplicationRecord.transaction do
  Seller.all.each do |seller|
    seller_store = seller.seller_info.store_info
    orderers = User.where(is_admin: nil, is_seller: nil, is_manager: nil).limit(100)
    5.times do
      #셀러의 스토어에 존재하는 상품 한개에서 세개
      products = seller_store.selected_products.sample((rand * 3).to_i + 1).map(&:product)
      #current cart가 비어있어, 상품을 추가하고 주문 생성이 가능한 user 한명
      orderer = orderers.select do |user|
        user.current_cart.items.empty?
      end.sample
      #대상 카트
      cart = orderer.current_cart
      cart_item_service = Store::CartItemService.new(cart, seller.seller_info)
      # 카트에 혹시 담겨있을 아이템을 뺍니다.
      cart_item_service.minus_all_item
      #카트에 대표상품을 1~3개 넣습니다.
      products.each do |product|
        cart_item_service.add(product.default_option.id, (rand * 3).to_i + 1)
      end
      order_param = {
        cart_id: cart.id,
        channel: Channel.default_channel
      }
      payment_param = {
        pay_method: 'bank'
      }
      order_create_service = Store::OrderCreateService.new(seller, order_param, ship_info_samples.sample, payment_param)
      order_create_service.save

      ap 'order and paper created'
      ap order_create_service.order_info
    end
    seller.seller_info.order_infos.where(cart: Cart.where(order_status: 2)).all.each do |order_info|
      # 결제 완료
      paid_at = Time.zone.now
      order_info.payment.update!(paid: true, paid_at: paid_at)
      order_info.cart.update!(order_status: 3)
      # 셀러 수익을 반영
      seller_papers = order_info.cart.items.map(&:item_sold_paper).compact
      seller_papers.each do |paper|
        paper.apply_seller_profit
        paper.pay!
      end

      # ap 'order payments completed'
      # ap order_info

      date_from = (Time.now - 5.month).to_f
      date_to = Time.now.to_f
      time = Time.at(rand * (date_to - date_from) + date_from)

      ap time

      order_info.update!(ordered_at: time, created_at: time)
      order_info.cart.update!(created_at: time)
      order_info.payment.update!(created_at: time, paid_at: (time + 2.hours))
      order_info.ship_info.update!(created_at: time)
      items = order_info.items.where.not(item_sold_paper: nil)
      items.each do |item|
        item.update!(created_at: time)
        item.item_sold_paper.update!(created_at: time, paid_at: (time + 2.hours))
      end

      # ap 'order is moved to past'
      # ap order_info

      # 25퍼 확률로 취소시킵니다.
      if (rand * 4) < 1
        order_info.cart.update!(order_status: 7)
        order_cancel_service = Store::OrderCancelService.new(order_info.cart, {}, order_info.order_status)
        order_cancel_service.cancel!
        # ap 'order is cancelled'
        # ap order_info
      end
    end
  end
end

# # 출금신청을 합니다. 돈이 없으면 못합니다.
# ApplicationRecord.transaction do
#   sellers.each do |seller|
#     seller_info = seller.seller_info
#     next if seller_info.withdrawable_profit.zero?
#
#     settlement = Sellers::SettlementStatement.new(
#       seller_info: seller_info,
#       settlement_amount: seller_info.withdrawable_profit,
#       status: 'requested',
#       requested_at: Time.now
#     )
#     settlement.write_initial_state
#     settlement.save
#     ap 'seller\'s settlement is requested'
#     ap settlement
#   end
# end
