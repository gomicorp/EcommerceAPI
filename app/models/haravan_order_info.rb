# == Schema Information
#
# Table name: haravan_order_infos
#
#  id               :bigint           not null, primary key
#  ordered_at       :datetime
#  total_price      :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  haravan_order_id :integer
#
class HaravanOrderInfo < ApplicationRecord
end
