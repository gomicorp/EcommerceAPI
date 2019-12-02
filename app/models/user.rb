class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:facebook]

  # Role scopes
  scope :admins, -> { where(is_admin: true) }
  scope :managers, -> { where(is_manager: true) }
  scope :sellers, -> { where(is_seller: true) }

  has_many :carts, -> { order(created_at: :desc) }
  has_many :order_infos, through: :carts
  has_many :payments, through: :order_infos
  has_many :ship_infos, through: :order_infos

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
