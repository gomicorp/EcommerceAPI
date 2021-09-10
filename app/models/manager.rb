class Manager < User
  default_scope -> { managers }

  has_many :memberships, dependent: :destroy
  has_many :companies, through: :memberships
  has_many :brands, -> { global }, class_name: 'Brand', through: :companies

  validates_presence_of :email, :name
  validates_uniqueness_of :email
end
