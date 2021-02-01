namespace :api, defaults: { format: :json } do
  namespace :v1 do
    resources :companies
    resources :product_items
    resources :product_collections
    resources :brands
    resources :product_items
    resources :product_collections
  end
end
