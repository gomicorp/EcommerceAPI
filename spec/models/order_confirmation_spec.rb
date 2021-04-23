# == Schema Information
#
# Table name: order_confirmations
#
#  id            :bigint           not null, primary key
#  contact_count :integer
#  memo          :text(65535)
#  status        :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  order_info_id :bigint           not null
#
# Indexes
#
#  index_order_confirmations_on_order_info_id  (order_info_id)
#
# Foreign Keys
#
#  fk_rails_...  (order_info_id => order_infos.id)
#
require 'rails_helper'

RSpec.describe OrderConfirmation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
