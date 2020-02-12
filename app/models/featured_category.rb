class FeaturedCategory < Category
  default_scope -> { where(featured: true) }
end
