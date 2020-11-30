# == Schema Information
#
# Table name: status_logs
#
#  id             :bigint           not null, primary key
#  code           :string(255)      not null
#  extra_info     :json
#  loggable_type  :string(255)      not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  loggable_id    :bigint           not null
#  status_code_id :bigint           not null
#
# Indexes
#
#  index_status_logs_on_loggable_type_and_loggable_id  (loggable_type,loggable_id)
#  index_status_logs_on_status_code_id                 (status_code_id)
#
# Foreign Keys
#
#  fk_rails_...  (status_code_id => status_codes.id)
#
class StatusLog < ApplicationRecord
  self.table_name = :status_logs
  self.abstract_class = true

  belongs_to :loggable, polymorphic: true

  validates_presence_of :loggable_id, :status_code_id

  before_create :before_create_hook

  private

  def before_create_hook
    if status_code.persisted?
      self.code = status_code.name
    end
  end
end
