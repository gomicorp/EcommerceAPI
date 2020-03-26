module Banner
  class Category < Base
    default_scope -> { where(banner_type: :category) }
  end
end
