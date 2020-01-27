module Haravan
  class Transaction < Api::Record
    self.schema = %i[
      amount
      created_at
      id
      kind
      order_id
      status
      currency
      haravan_transaction_id
      external_transaction_id
    ]
  end
end

=begin

                     :amount => 300000.0,
              :authorization => nil,
                 :created_at => "2020-01-27T09:52:34.935Z",
                  :device_id => nil,
                    :gateway => "Thanh toán online qua ví MoMo",
                         :id => 1039837745,
                       :kind => "capture",
                   :order_id => 1100704685,
                    :receipt => nil,
                     :status => nil,
                       :test => false,
                    :user_id => 0,
                :location_id => 649965,
            :payment_details => nil,
                  :parent_id => 1039837707,
                   :currency => "VND",
     :haravan_transaction_id => "140171000419314",
    :external_transaction_id => "4448693353",
                 :send_email => false

=end
