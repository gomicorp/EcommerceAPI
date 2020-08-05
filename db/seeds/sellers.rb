# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



#=== seller ===#
def seller_seed_breeder(n)
  return [] unless n > 0

  n -= 1
  seller_seed_breeder(n) + [{
                              name: 'gomi_seller_' << SecureRandom.base36(2),
                              email: "gomi_seller_#{ SecureRandom.base36(2) }@gomi.com",
                              password: 'elimsimog2020',
                              birth_day: (DateTime.now - 20.years),
                              gender: ['F', 'N', nil].sample,
                              phone_number: "010-#{ Random.rand(1.0).to_s.slice(2..9).insert(4, '-') }"
                            }]
end

seller_set = seller_seed_breeder 20
seller_set.each do |seller_attr|
  seller = Seller.create(seller_attr)
  ap 'created'
  Authentication.create(user_id: seller.id, provider: 'facebook', uid: SecureRandom.uuid)
  ap seller
end
#=== sellers seller info ===#
#=== sellers store info ===#
#=== sellers account info ===#
def seller_info_seed_breeder(seller, store, account)
  {
    seller: seller,
    store_info: store,
    account_info: account,
    grade: Sellers::Grade.beginner
  }
end
Seller.all.each do |seller|
  ApplicationRecord.transaction do
    seller_info = Sellers::SellerInfo.create(seller: seller, grade: Sellers::Grade.beginner)
    store = Sellers::StoreInfo.create(
      seller_info: seller_info,
      name: 'pop S2 up sotre for' << seller.name,
      comment: 'Here is test store'
    )
    store.update(
      url: 'https://gomistore.in.th/popup_store/' << store.id.to_s,
      )
    ap 'created'
    ap store

    account = Sellers::AccountInfo.create(
      seller_info: seller_info,
      country: 'global',
      bank: %w[kakao kb shinhan woori].sample,
      account_number: Random.rand(1.0).to_s.slice(2..14),
      owner_name: '홍길동'
    )
    ap 'created'
    ap account

    seller_info.update(seller_info_seed_breeder(seller, store, account))
    ap 'created'
    ap seller_info
  end
end

ApplicationRecord.transaction do
  #=== permit_change_list ===#
  Sellers::SellerInfo.all.each(&:init_permit_status!)
  Sellers::SellerInfo.first(4).each do |seller_info|
    seller_info.play_permit!
    ap 'permitted'
    ap({ seller: seller_info.seller.name, status: seller_info.permit_status.status })
  end
end

#=== selected_product ===#
#live_products => 판매중이고, 디폴트 옵션이 잔여 수량이 있는 상품
live_products = Product.running.select do |product|
  product.default_option && !product.default_option.available_quantity.zero?
end
# live_products중의 하나를 셀러의 스토어에 연결
ApplicationRecord.transaction do
  Sellers::StoreInfo.all.each do |seller_store|
    linkable_product = live_products.sample
    Sellers::SelectedProduct.create(store_info: seller_store, product: linkable_product)
    ap 'product linked'
    ap( { store: seller_store.name, product: linkable_product })
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

ApplicationRecord.transaction do
  Sellers::SellerInfo.permitted.map(&:store_info).each do |seller_store|
    #셀러의 스토어에 존재하는 상품 한개
    product = seller_store.selected_products.first.product
    #current cart가 비어있어, 상품을 추가하고 주문 생성이 가능한 user 한명
    orderer = User.where(is_admin: nil, is_seller: nil, is_manager: nil).limit(100).select do |user|
      user.current_cart.items.empty?
    end.sample
    #대상 카트
    cart = orderer.current_cart
    #카트에 product option를 넣습니다.
    cart_item_service = Store::CartItemService.new(cart)
    cart_item_service.add(product.default_option.id, 1)
    order_param = {
      cart_id: cart.id,
      channel: Channel.default_channel
    }
    payment_param = {
      pay_method: 'bank'
    }
    order_create_service = Store::OrderCreateService.new(seller_store.seller_info.seller, order_param, ship_info_samples.sample, payment_param)
    order_create_service.save

    ap 'order and paper created'
    ap order_create_service.order_info
  end
end
