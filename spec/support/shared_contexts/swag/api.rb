require 'rails_helper'

shared_examples 'API' do |api_name|
  tags "#{api_name} API"
  consumes 'application/json'
end
