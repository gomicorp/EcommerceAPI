class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:facebook]

  # 역할과 관련된 스코프
  scope :admins, -> { where(is_admin: true) }
  scope :managers, -> { where(is_manager: true) }
  scope :sellers, -> { where(is_seller: true) }

  # 장바구니 또는 주문으로부터의 모델관계
  has_many :carts, -> { order(created_at: :desc) }
  has_many :order_infos, class_name: 'OrderInfo', through: :carts
  has_many :payments, class_name: 'Payment', through: :order_infos
  has_many :ship_infos, class_name: 'ShipInfo', through: :order_infos

  # 배송지에 대하여..
  has_many :user_shipping_address, dependent: :destroy
  has_many :shipping_addresses, through: :user_shipping_address
  belongs_to :default_address, class_name: 'ShippingAddress', optional: true

  # 수령인에 대하여..
  has_many :user_receiver, dependent: :destroy
  has_many :receivers, through: :user_receiver
  belongs_to :default_receiver, class_name: 'Receiver', optional: true

  def cart_attached?
    carts.active.any?
  end

  def current_cart
    carts.active.current
  end

  def self.find_for_oauth(auth, signed_in_resource = nil)
    user = signed_in_resource || find_by(provider: auth.provider, uid: auth.uid)

    # Directly return user if already exists or signed_in.
    return user if user

    # Make new user if user was not founded.

    # first, check any user has email what auth instance has.
    user = find_or_initialize_by(email: auth.info.email)

    unless user.persisted?
      # if nobody have this email, create new user.

      # Common Auth has.
      user.provider = auth.provider
      user.uid = auth.uid
      user.password = Devise.friendly_token[0, 20]

      # It's a little difference for each provider's auth hash.
      # Make sure which key and value of auth data is proper for users attributes.
      case auth.provider
      when 'facebook'
        user.email = auth.info.email || "#{auth.uid}@#{auth.provider}.gomicorp.com"
        user.name = auth.info.name
        user.profile_image = auth.info.image

      when 'kakao' # Note. Kakao doesn't support email field.
        user.profile_image = auth.info.image
      end

      user.save!
    end

    user
  end

  # Enable to regist with doesn't have email field.
  def email_required?
    false
  end
end
