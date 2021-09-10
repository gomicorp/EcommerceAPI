class Membership < ApplicationRecord
  enum role: %i[member admin owner]

  belongs_to :company
  belongs_to :manager

  validates_uniqueness_of :manager_id, scope: [:company]
end
