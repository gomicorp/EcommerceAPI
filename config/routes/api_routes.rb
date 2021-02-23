namespace :api, defaults: { format: :json } do
  namespace :v1, except: %i[new edit] do
    resources :companies
    resources :product_items
    resources :product_collections
    resources :brands
    resources :managers do
      resources :companies, only: %i[index show], controller: 'managers/companies'
      resources :memberships, controller: 'managers/memberships'
    end
  end
end
