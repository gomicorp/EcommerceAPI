# == Schema Information
#
# Table name: approve_requests
#
#  id              :bigint           not null, primary key
#  alive           :boolean          default(TRUE), not null
#  approvable_type :string(255)
#  status          :integer          default("pending"), not null
#  created_at      :datetime         default(Tue, 10 Dec 2019 09:23:52 UTC +00:00), not null
#  updated_at      :datetime         default(Tue, 10 Dec 2019 09:23:52 UTC +00:00), not null
#  approvable_id   :bigint
#
# Indexes
#
#  index_approve_requests_on_approvable_type_and_approvable_id  (approvable_type,approvable_id)
#
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
