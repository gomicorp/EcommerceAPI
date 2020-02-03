class Zohomap < ApplicationRecord
  belongs_to :zohoable, polymorphic: true
  validates_presence_of :zoho_id
  validates_uniqueness_of :zoho_id
end
