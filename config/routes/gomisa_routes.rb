namespace :gomisa do
  readonly = %i[index show]

  resources :companies do
    resources :brands, module: :companies, only: readonly
  end
  resources :brands do
    resource :company, module: :brands, only: readonly
  end


  resources :product_item_groups do
    resources :items, module: :product_item_groups do
      resources :adjustments, module: :items
    end
  end

  # 카테고리 관리
  resources :product_collections do
    scope module: :product_collections do
      resources :lists
      resources :elements, only: %i[create destroy]
    end
  end

  resources :product_items
  resources :adjustments

  post '/update', to: 'update#index'
end
