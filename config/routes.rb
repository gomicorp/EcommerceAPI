Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }
  
  # global file crud (active_storage)
  resources :files, only: %i[show create destroy]
  
  draw :partner_center_routes
  draw :gomisa_routes

  draw :common_routes
  draw :sellers_routes

  namespace :external_channels do
    get 'code', to: 'code'
    post 'batch', to: 'batch'
  end

  namespace :haravan do
    namespace :settlement do
      resources :brands, only: %i[index show]
    end
  end
  
  devise_for :pandals
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
end
