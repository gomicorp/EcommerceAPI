# == Schema Information
#
# Table name: companies
#
#  id          :bigint           not null, primary key
#  name        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :text(65535)
#
class Company < ApplicationRecord
  include Approvable
  has_many :brands, dependent: :destroy

  has_many :memberships, dependent: :destroy
  has_many :managers, through: :memberships

  # def ownership
  #   @ownership ||= memberships.owner.take
  # end
  has_one :ownership, -> { owner }, class_name: 'Membership'

  # def owner
  #   ownership.manager
  # end
  has_one :owner, through: :ownership, source: :manager

  # Company::ApproveRequest
  class ApproveRequest < ::ApproveRequest
    default_scope { where(approvable_type: :Company) }
  end
end
