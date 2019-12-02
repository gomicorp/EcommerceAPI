class Manager < User
  default_scope -> { managers }

  has_many :memberships
  has_many :companies, through: :memberships
end
