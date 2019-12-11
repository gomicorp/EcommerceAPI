def approve_requests_on(scoped_resource)
  option = {
    only: %i[index show create destroy],
    module: scoped_resource,
    as: "#{scoped_resource}_approve_requests"
  }

  collection { resources :approve_requests, option }
end
