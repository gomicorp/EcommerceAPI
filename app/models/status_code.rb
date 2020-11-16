# == Schema Information
#
# Table name: status_codes
#
#  id          :bigint           not null, primary key
#  comment     :text(65535)
#  domain_type :string(255)
#  name        :string(255)      default(""), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  country_id  :bigint           not null
#
# Indexes
#
#  index_status_codes_on_country_id  (country_id)
#
# Foreign Keys
#
#  fk_rails_...  (country_id => countries.id)
#
class StatusCode < NationRecord
  self.table_name = :status_codes
  self.abstract_class = true

  # 디버깅 용도로만 제한적으로 사용
  has_many :loggables, through: :status_logs
end
