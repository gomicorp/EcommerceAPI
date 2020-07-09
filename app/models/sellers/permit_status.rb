module Sellers
  class PermitStatus < ApplicationRecord
    validates_uniqueness_of :status
    belongs_to :permit_change_list, class_name: 'Sellers::PermitChangeList'
  end
end
