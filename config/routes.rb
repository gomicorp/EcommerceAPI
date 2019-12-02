Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }

  namespace :partner do
    namespace :users do
      post '/', to: 'registrations#create'
      get '/:id', to: 'registrations#show'
      post 'sign_in', to: 'sessions#create'
    end

    resources :companies
    resources :managers, only: :index
  end
end
