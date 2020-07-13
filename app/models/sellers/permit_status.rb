module Sellers
  class PermitStatus < ApplicationRecord
    validates_uniqueness_of :status, case_sensitive: false
    validates_inclusion_of :status, in: %w[applied permitted stopped]
    belongs_to :permit_change_list, class_name: 'Sellers::PermitChangeList'

    APPLIED = find_or_create_by(status: 'applied')
    PERMITTED = find_or_create_by(status: 'permitted')
    STOPPED = find_or_create_by(status: 'stopped')

    def self.applied
      APPLIED
    end

    def self.permitted
      PERMITTED
    end

    def self.stopped
      STOPPED
    end
  end
end
