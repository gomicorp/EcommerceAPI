class ApproveRequest < ApplicationRecord
  enum status: %i[pending rejected accepted]
  belongs_to :approvable

  scope :alive, -> { where(alive: true) }
  scope :dead, -> { where(alive: false) }
end
