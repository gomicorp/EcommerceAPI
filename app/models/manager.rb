class Manager < User
  default_scope -> { managers }

  has_many :memberships, dependent: :destroy
  has_many :companies, through: :memberships
  has_many :brands, through: :companies
end
