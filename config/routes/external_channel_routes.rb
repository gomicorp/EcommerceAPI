namespace :external_channels do
  get 'code', to: 'code'
  post 'batch', to: 'batch'
  post 'batch_all', to: 'batch_all'
end
