namespace :gomisa do
  readonly = %i[index show]

  resources :companies, only: readonly do
    resources :brands, module: :companies, only: readonly
  end
  resources :brands, only: readonly do
    resource :company, module: :brands, only: readonly
  end

  resources :product_items 
  get '/update', to: 'update#index'
end
