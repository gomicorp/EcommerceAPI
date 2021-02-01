Rails.application.config.generators do |g|
  g.test_framework :rspec #, controller_specs: false, view_specs: false, routing_specs: false, helper_specs: false
end
