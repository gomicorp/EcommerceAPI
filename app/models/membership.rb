class Membership < ApplicationRecord
  enum role: %i[member admin owner]

  belongs_to :company
  belongs_to :manager
end
