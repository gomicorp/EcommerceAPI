require 'swagger_helper'

RSpec.describe Api::V1::CompaniesController, type: :request do
  describe 'GET /api/v1/companies' do
    it 'works! (now write some real specs)' do
      get api_v1_companies_path
      expect(response).to have_http_status(200)
    end
  end
end
