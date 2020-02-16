namespace :gomisa do
  readonly = %i[index show]

  resources :companies do
    resources :brands, module: :companies, only: readonly
  end
  resources :brands do
    resource :company, module: :brands, only: readonly
  end
  resources :product_item_groups
  resources :product_items
  resources :adjustments

  post '/update', to: 'update#index'
end
