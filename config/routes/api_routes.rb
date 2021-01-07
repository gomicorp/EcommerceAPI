namespace :api, defaults: { format: :json } do
  namespace :v1 do
    resources :companies
  end
end
