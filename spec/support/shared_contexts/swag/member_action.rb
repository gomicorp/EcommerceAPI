require 'rails_helper'

shared_examples 'Member action' do
  parameter name: :id, in: :path, type: :integer
end
