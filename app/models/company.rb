class Company < ApplicationRecord
  enum approve_status: %i[pending rejected accepted]
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
end
