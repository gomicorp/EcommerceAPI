require 'rails_helper'

shared_examples 'Login required' do |required_preset_block|
  parameter name: 'Authorization', in: :header, type: :string, default: auth_token

  response '401', '로그인을 해야 합니다.' do
    let(:Authorization) { '' }
    instance_exec(&required_preset_block) if required_preset_block
    run_test!
  end
end
