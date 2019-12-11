class ApproveRequest < ApplicationRecord
  enum status: %i[pending rejected accepted]
  belongs_to :approvable, polymorphic: true

  scope :alive, -> { where(alive: true) }
  scope :dead, -> { where(alive: false) }

  before_create :set_timestamp

  def before
    before_all.last
  end

  def before_all
    self.class.where(approvable: approvable).where.not(id: id)
  end

  def alive_before
    before_all.alive
  end

  def dead_before!
    alive_before.update_all(alive: false)
  end

  def rollback!
    _before = before
    transaction do
      destroy
      _before.update(alive: true)
    end
  end

  private

  def set_timestamp
    now = Time.zone.now
    self.created_at = now
    self.updated_at = now
  end
end
