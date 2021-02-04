require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.
#
# Also compared to earlier versions of this generator, there are no longer any
# expectations of assigns and templates rendered. These features have been
# removed from Rails core in Rails 5, but can be added back in via the
# `rails-controller-testing` gem.

RSpec.describe Api::V1::CompaniesController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # Company. As you add validations to Company, be sure to
  # adjust the attributes here as well.
  render_views

  STRING_MAX_LENGTH = 256
  JSON_CONTENT_TYPE = 'application/json; charset=utf-8'.freeze

  let(:valid_attributes) do
    { name: Faker::Company.name }
  end

  let(:invalid_attributes) do
    { name: nil }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # Api::V1::CompaniesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe '업체 리스트 조회. GET #index' do
    context '다른 입력 없이 URL 만으로 기본 요청한 경우' do
      before { Company.create! valid_attributes }
      subject { get :index, params: { format: :json }, session: valid_session }
      it { is_expected.to be_successful }
    end
  end

  describe '업체 상세. GET #show' do
    context '요청 성공에 대하여' do
      let(:company) { Company.create! valid_attributes }
      subject { get :show, params: { id: company.id, format: :json }, session: valid_session }
      it { is_expected.to be_successful }
    end

    context '업체를 찾을 수 없으면' do
      subject { get :show, params: { id: 0, format: :json }, session: valid_session }
      it { is_expected.to be_not_found }
    end
  end

  describe '업체 신규 등록. POST #create' do
    # context '입력이 올바른 경우' do
    #   it '업체를 생성하고 생성된 업체를 반환합니다.' do
    #     expect do
    #       post :create, params: { company: valid_attributes, format: :json }, session: valid_session
    #     end.to change(Company, :count).by(1)
    #     expect(response).to have_http_status(:created)
    #     expect(response.content_type).to eq(JSON_CONTENT_TYPE)
    #   end
    # end
    #
    # context '입력이 잘못된 경우' do
    #   it 'renders a JSON response with errors for the new company' do
    #     post :create, params: { company: invalid_attributes, format: :json }, session: valid_session
    #     expect(response).to have_http_status(:unprocessable_entity)
    #     expect(response.content_type).to eq(JSON_CONTENT_TYPE)
    #   end
    # end
  end

  describe 'PUT #update' do
    # context 'with valid params' do
    #   let(:new_attributes) do
    #     { name: Faker::Company.name }
    #   end
    #
    #   it 'updates the requested company' do
    #     company = Company.create! valid_attributes
    #     put :update, params: { id: company.to_param, company: new_attributes, format: :json }, session: valid_session
    #     company.reload
    #     expect(company.persisted?).to eq(true)
    #   end
    #
    #   it 'renders a JSON response with the company' do
    #     company = Company.create! valid_attributes
    #
    #     put :update, params: { id: company.to_param, company: valid_attributes, format: :json }, session: valid_session
    #     expect(response).to have_http_status(:ok)
    #     expect(response.content_type).to eq(JSON_CONTENT_TYPE)
    #   end
    # end
    #
    # context 'with invalid params' do
    #   it 'renders a JSON response with errors for the company' do
    #     company = Company.create! valid_attributes
    #
    #     put :update, params: { id: company.to_param, company: invalid_attributes, format: :json }, session: valid_session
    #     expect(response).to have_http_status(:unprocessable_entity)
    #     expect(response.content_type).to eq(JSON_CONTENT_TYPE)
    #   end
    # end
  end

  describe 'DELETE #destroy' do
    # it 'destroys the requested company' do
    #   company = Company.create! valid_attributes
    #   expect do
    #     delete :destroy, params: { id: company.to_param, format: :json }, session: valid_session
    #   end.to change(Company, :count).by(-1)
    # end
  end
end