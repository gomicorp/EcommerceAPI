require 'rails_helper'

RSpec.describe Api::V1::CompaniesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/companies').to route_to('api/v1/companies#index', format: :json)
    end

    it 'routes to #show' do
      expect(get: '/api/v1/companies/1').to route_to('api/v1/companies#show', id: '1', format: :json)
    end

    it 'routes to #create' do
      expect(post: '/api/v1/companies').to route_to('api/v1/companies#create', format: :json)
    end

    it 'routes to #update via PUT' do
      expect(put: '/api/v1/companies/1').to route_to('api/v1/companies#update', id: '1', format: :json)
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/api/v1/companies/1').to route_to('api/v1/companies#update', id: '1', format: :json)
    end

    it 'routes to #destroy' do
      expect(delete: '/api/v1/companies/1').to route_to('api/v1/companies#destroy', id: '1', format: :json)
    end
  end
end
