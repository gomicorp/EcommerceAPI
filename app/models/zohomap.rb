# == Schema Information
#
# Table name: zohomaps
#
#  id              :bigint           not null, primary key
#  zoho_id         :string(255)
#  zohoable_id     :bigint
#  zohoable_type   :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  zoho_updated_at :datetime
#  archived_at     :datetime
#
class Zohomap < ApplicationRecord
  belongs_to :zohoable, polymorphic: true
  validates_presence_of :zoho_id
  validates_uniqueness_of :zoho_id
end
