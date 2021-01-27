require 'rails_helper'

shared_examples 'Public endpoint' do
  response '200', :ok do
    context '다른 입력 없이 URL 만으로 기본 요청한 경우' do
      run_test!
    end
  end
end
