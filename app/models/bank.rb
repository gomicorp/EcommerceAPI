# == Schema Information
#
# Table name: banks
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  country_id :bigint           not null
#
# Indexes
#
#  index_banks_on_country_id  (country_id)
#
# Foreign Keys
#
#  fk_rails_...  (country_id => countries.id)
#
class Bank < ApplicationRecord
  belongs_to :country
  has_many :sellers_account_infos, :class_name => 'Sellers::AccountInfo'
end
