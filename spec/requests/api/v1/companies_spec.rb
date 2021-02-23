require 'swagger_helper'

RSpec.describe 'Companies API', type: :request do
  before(:each) { create_test_user }
  before(:each) { Company.find_or_create_by(company_params) }

  shared_examples 'API' do |api_name|
    tags "#{api_name} API"
    consumes 'application/json'
  end

  shared_examples 'member action' do
    parameter name: :id, in: :path, type: :integer
  end

  shared_examples 'Login Required' do |required_preset_block|
    parameter name: 'Authorization', in: :header, type: :string, default: auth_token

    response '401', '로그인을 해야 합니다.' do
      let(:Authorization) { '' }
      instance_exec(&required_preset_block) if required_preset_block
      run_test!
    end
  end

  shared_examples 'Permitted resource params definition' do
    parameter name: :company, in: :body, schema: {
      type: :object,
      properties: {
        name: { type: :string }
      },
      required: %w[name]
    }
  end

  shared_examples 'Allow public and url only request' do
    response '200', :ok do
      context '다른 입력 없이 URL 만으로 기본 요청한 경우' do
        run_test!
      end
    end
  end

  let(:company_params) { { name: 'gomi' } }

  path '/api/v1/companies' do
    get '업체 리스트 조회. Public' do
      it_behaves_like 'API', 'Company'
      it_behaves_like 'Allow public and url only request'
    end

    post '업체 신규 등록. By Manager' do
      it_behaves_like 'API', 'Company'
      it_behaves_like 'Login Required' do
        let(:company) { company_params }
      end

      it_behaves_like 'Permitted resource params definition'

      response '201', 'company created' do
        let(:Authorization) { auth_token }
        let(:company) { company_params }
        run_test!
      end

      response '422', :unprocessable_entity do
        context '등록 정보에 업체 이름이 누락된 경우' do
          let(:Authorization) { auth_token }
          let(:company) { {} }
          run_test!
        end
      end
    end
  end

  path '/api/v1/companies/{id}' do
    get '업체 상세. Public' do
      it_behaves_like 'API', 'Company'
      it_behaves_like 'member action'

      response '200', :success do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 description: { type: :string, nullable: true }
               }

        let!(:id) { Company.create(name: Faker::Company.name).id }
        run_test!
      end

      response '404', :not_found do
        let!(:id) { 0 }
        run_test!
      end
    end

    put '업체 수정. By Owner' do
      it_behaves_like 'API', 'Company'
      it_behaves_like 'member action'
      it_behaves_like 'Login Required' do
        let!(:id) { Company.find_or_create_by(company_params).id }
        let(:company) { company_params }
      end

      it_behaves_like 'Permitted resource params definition'

      # TODO: 로그인이 되어있더라도 권한을 가진 유저가 아니면 403.

      response '200', :success do
        # let!(:user) { create_test_user }
        let(:Authorization) { auth_token }
        let!(:id) { Company.find_or_create_by(company_params).id }
        let(:company) { company_params.merge(name: Faker::Company.name) }
        run_test!
      end

      response '404', :not_found do
        # let!(:user) { create_test_user }
        let(:Authorization) { auth_token }
        let!(:id) { 0 }
        let(:company) { company_params.merge(name: Faker::Company.name) }
        run_test!
      end

      response '422', :unprocessable_entity do
        context '등록 정보에 업체 이름이 누락된 경우' do
          # let!(:user) { create_test_user }
          let(:Authorization) { auth_token }
          let!(:id) { Company.find_or_create_by(company_params).id }
          let(:company) { company_params.merge(name: nil) }
          run_test!
        end
      end
    end

    delete '업체 삭제. By Owner' do
      it_behaves_like 'API', 'Company'
      it_behaves_like 'member action'
      it_behaves_like 'Login Required' do
        let!(:id) { Company.find_or_create_by(company_params).id }
        let(:company) { company_params }
      end

      # TODO: 로그인이 되어있더라도 권한을 가진 유저가 아니면 403.

      response '204', :no_content do
        # let!(:user) { create_test_user }
        let(:Authorization) { auth_token }
        let!(:id) { Company.find_or_create_by(company_params).id }
        run_test!
      end

      response '404', :not_found do
        # let!(:user) { create_test_user }
        let(:Authorization) { auth_token }
        let!(:id) { 0 }
        run_test!
      end
    end
  end
end
