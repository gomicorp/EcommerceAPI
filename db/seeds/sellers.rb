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
end

#=== seller ===#
# def seller_seed_breeder(n)
#   return [] unless n > 0
#
#   n -= 1
#   seller_seed_breeder(n) + [{
#                               name: 'gomi_seller_' << SecureRandom.base36(2),
#                               email: "gomi_seller_#{ SecureRandom.base36(2) }@gomi.com",
#                               password: 'elimsimog2020',
#                               birth_day: (DateTime.now - 20.years),
#                               gender: ['F', 'N', nil].sample,
#                               phone_number: "010-#{ Random.rand(1.0).to_s.slice(2..9).insert(4, '-') }"
#                             }]
# end
#
# seller_set = seller_seed_breeder 2
# seller_set.each do |seller_attr|
#   seller = Seller.create(seller_attr)
#   ap 'created'
#   Authentication.create(user_id: seller.id, provider: 'facebook', uid: SecureRandom.uuid)
#   ap seller
# end

seller_tester_emails = [
  'tobepygrammer',
  'titiwood@nate.com',
  'ywsis@daum.net'
]

sellers = seller_tester_emails.map do |tester_mail|
  tester = User.where('email like ?', "%#{tester_mail}%").first
  next if tester.nil?

  tester.update!(is_seller: true)
  Seller.find(tester.id)
end.compact

#=== sellers seller info ===#
#=== sellers store info ===#
#=== sellers account info ===#
def seller_info_seed_breeder(seller, store, account)
  {
    seller: seller,
    store_info: store,
    account_infos: [account],
    grade: Sellers::Grade.beginner,
    sns_name: 'facebook',
    sns_id: seller.email.split('@').first
  }
end

sellers.select{ |s| s.seller_info.nil? }.each do |seller|
  ApplicationRecord.transaction do
    seller_info = Sellers::SellerInfo.create(seller: seller, grade: Sellers::Grade.beginner)
    store = Sellers::StoreInfo.create(
      seller_info: seller_info,
      name: 'pop S2 up sotre for' << seller.name,
      comment: 'Here is test store'
    )
    store.update!(
      url: 'https://gomistore.in.th/popup_store/' << store.id.to_s,
    )
    ap 'store info is created'
    ap store

    account = Sellers::AccountInfo.create(
      seller_info: seller_info,
      bank: Bank.all.sample,
      account_number: Random.rand(1.0).to_s.slice(2..14),
      owner_name: seller.name
    )
    ap 'account info is created'
    ap account.save!

    seller_info.update!(seller_info_seed_breeder(seller, store, account))
    ap 'seller info is created'
    ap seller_info
  end
end

ApplicationRecord.transaction do
  #=== permit_change_list ===#
  sellers.each do |seller|
    seller_info = seller.seller_info
    seller_info.permit_change_lists << Sellers::PermitChangeList.create(
      permit_status: Sellers::PermitStatus.permitted
    )
    ap 'permitted'
  end
end

#=== selected_product ===#
#live_products => 판매중이고, 디폴트 옵션이 잔여 수량이 있는 상품
live_products = Product.running.select do |product|
  product.default_option && !product.default_option.available_quantity.zero?
end
# live_products중 두개 셀러의 스토어에 연결
ApplicationRecord.transaction do
  sellers.map(&:seller_info).map(&:store_info).each do |seller_store|
    linkable_products = live_products.sample(2)

    Sellers::SelectedProduct.create(store_info: seller_store, product: linkable_products.first)
    Sellers::SelectedProduct.create(store_info: seller_store, product: linkable_products.last)
    ap 'product linked'
    ap({store: seller_store.name, product: linkable_products})
  end
end

#=== order by seller store ===#
#=== item sold paper ===#
#ship_info_samples => 기존에 존재하는 가장 최근의 5개 ship info에서 reference와 timestamp를 제거, 샘플값으로 활용
ship_info_samples = OrderInfo.last(5).map(&:ship_info).map do |ship_info|
  ship_info.attributes.tap do |sample|
    sample.delete('id')
    sample.delete('order_info_id')
    sample.delete('created_at')
    sample.delete('updated_at')
    sample
  end
end

# 주문이 가능한 유저데이터로, 스토어마다 주문을 3번 합니다.
# 3개의 주문 중 2개의 주문을 결제완료처리합니다.
ApplicationRecord.transaction do
  sellers.each do |seller|
    seller_store = seller.seller_info.store_info
    3.times do
      #셀러의 스토어에 존재하는 상품 한개
      product = seller_store.selected_products.first.product
      #current cart가 비어있어, 상품을 추가하고 주문 생성이 가능한 user 한명
      orderer = User.where(is_admin: nil, is_seller: nil, is_manager: nil).limit(100).select do |user|
        user.current_cart.items.empty?
      end.sample
      #대상 카트
      cart = orderer.current_cart
      #카트에 product option를 넣습니다.
      cart_item_service = Store::CartItemService.new(cart, seller.seller_info)
      cart_item_service.add(product.default_option.id, 1)
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
    seller.seller_info.order_infos.sample(2).each do |order_info|
      paid_at = Time.zone.now
      order_info.payment.update!(paid: true, paid_at: paid_at)
      # 셀러 수익을 반영
      seller_papers = order_info.cart.items.map(&:item_sold_paper).compact
      seller_papers.each do |paper|
        paper.apply_seller_profit
        paper.pay!
      end
      ap 'order payments completed'
      ap order_info
    end
  end
end

# 셀러 중에 2명을 뽑아서 출금신청을 합니다.
ApplicationRecord.transaction do
  sellers.sample(2).each do |seller|
    seller_info = seller.seller_info
    settlement = Sellers::SettlementStatement.new(
      seller_info: seller_info,
      settlement_amount: seller_info.withdrawable_profit,
      status: 'requested'
    )
    settlement.write_initial_state
    ap 'seller\'s settlement is requested'
    ap seller_info
    ap settlement
  end
end
