class Admin < User
  default_scope -> { admins }
end
