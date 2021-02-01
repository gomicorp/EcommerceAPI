module Users
  module Managers
    class WithCompanyDecorator < DefaultDecorator
      data_keys_from_model :manager
      data_key :companies, with: Companies::DefaultDecorator
    end
  end
end
