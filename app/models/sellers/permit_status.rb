module Sellers
  class PermitStatus < ApplicationRecord
    validates_uniqueness_of :status
    validates_inclusion_of :status, in: %w[applied permitted stopped]
    has_many :permit_change_list, class_name: 'Sellers::PermitChangeList', dependent: :destroy

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

    def name
      status.to_sym
    end
  end
end
