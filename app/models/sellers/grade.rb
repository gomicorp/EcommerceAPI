# == Schema Information
#
# Table name: sellers_grades
#
#  id              :bigint           not null, primary key
#  name            :string(255)
#  commission_rate :decimal(10, 2)   default(0.0), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
module Sellers
  class Grade < ApplicationRecord
    validates_inclusion_of :name, in: %w[beginner bronze silver gold]
    validates_uniqueness_of :name, case_sensitive: false

    BEGINNER = find_or_create_by(name: 'beginner', commission_rate: 0.05)
    BRONZE = find_or_create_by(name: 'bronze', commission_rate: 0.1)
    SILVER = find_or_create_by(name: 'silver', commission_rate: 0.15)
    GOLD = find_or_create_by(name: 'gold', commission_rate: 0.2)

    def self.beginner
      BEGINNER
    end

    def self.bronze
      BRONZE
    end

    def self.silver
      SILVER
    end

    def self.gold
      GOLD
    end
  end
end
