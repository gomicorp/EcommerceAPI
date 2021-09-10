module Banner
  class Home < Base
    default_scope -> { where(banner_type: :home) }
  end
end
