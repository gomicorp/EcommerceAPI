namespace :gomisa do
  readonly = %i[index show]

  resources :companies do
    resources :brands, module: :companies, only: readonly
  end

  resources :brands do
    resource :company, module: :brands, only: readonly
  end

  resources :product_item_groups do
    resources :items, module: :product_item_groups
  end

  resources :product_items do
    resources :adjustments, module: :product_items
  end

  resources :product_collections do
    scope module: :product_collections do
      resources :lists
      resources :elements, only: %i[create destroy]
    end
  end

  resources :adjustments
end
