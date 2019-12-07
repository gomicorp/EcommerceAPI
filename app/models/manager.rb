class Manager < User
  default_scope -> { managers }

  has_many :memberships, dependent: :destroy
  has_many :companies, through: :memberships
end
