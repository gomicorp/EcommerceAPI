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

  resource :external_channels, controller: 'external_channels', only: '%i[batch]' do
    collection do
      get 'code'
      post 'batch'
    end
  end

  namespace :haravan do
    namespace :settlement do
      resources :brands, only: %i[index show]
    end
    resource :webhook, controller: 'webhook', only: '%i[webhooking regist logged_in]' do
      collection do
        get 'webhooking', action: 'regist'
        post 'webhooking'
        post 'logged_in'
        post 'installed'
      end
    end
  end
  
  devise_for :pandals
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
end
