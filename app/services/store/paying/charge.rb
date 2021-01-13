module Store
  module Paying
    class Charge
      attr_reader :status, :charge_info

      def initialize(charge_info)
        @status_table = {
          # omise case
          # 미결제 : pending
          # 결제완료 : successful
          # 결제취소, 결제실패 : failed
          th: {
            pending: :progress,
            successful: :done,
            failed: :revert
          },
          # iamport case
          # 미결제 : ready
          # 결제완료 : paid
          # 결제취소 : cancelled
          # 결제실패 : failed
          ko: {
            ready: :progress,
            paid: :done,
            cancelled: :revert,
            failed: :revert
          }
        }.freeze

        @charge_info = charge_info
        @current_country = ENV['APP_COUNTRY'].to_sym
        @status = set_status if charge_info
      end

      def payment
        charge_id = case @current_country
                    when :th
                      charge_info.id
                    when :ko
                      charge_info.dig('merchant_uid')
                    else
                      nil
                    end
        @payment ||= Payment.find_by(charge_id: charge_id)
      end

      def currency
        @currency ||= charge_info.dig(:currency)
      end

      def card
        # omise case
        if @current_country == :th
          card_source = charge_info.card
          @card ||= {
            card_name: card_source.brand,
            card_number: [card_source.first_digits || '****', ' **** **** ', card_source.last_digits || '****'].join,
            expiration_month: card_source.expiration_month,
            expiration_year: card_source.expiration_year,
            name: card_source.name
          }
        else
          # iamport case
          @card ||= {
            card_name: charge_info.dig(:card_name),
            card_number: parse_card_num(charge_info.dig(:card_number)),
            card_quota: charge_info.dig(:card_quota)
          }
        end
      end

      def paid?
        status == :done
      end

      def cancelled?
        # omise case
        return charge_info.refunds.data.any? if @current_country == :th

        # iamport case
        charge_info.dig(:cancel_history).any?
      end

      def paid_at
        @paid_at ||= if @current_country == :th
                       # omise case
                       Time.parse(charge_info.paid_at)
                     else
                       # iamport case
                       Time.at charge_info.dig(:paid_at)
                     end
      end

      def failed_at
        # iamport case
        return Time.at charge_info.dig(:failed_at) if charge_info.dig(:failed_at)

        nil
      end

      def expired_at
        @expired_at ||= if @current_country == :th
                          # omise_case
                          Time.parse(charge_info.expired_at)
                        else
                          # iamport case
                          Time.at(charge_info.dig(:started_at)) + 30.minutes
                        end
      end

      def fail_reason
        @fail_reason ||= if @current_country == :th
                           # omise case
                           charge_info.failure_code
                         else
                           # iamport case
                           charge_info.dig(:fail_reason)
                         end
      end

      def order_number
        description.is_a?(Hash) ? description.dig(:order) : nil
      end

      def authorize_uri
        @authorize_uri ||= if @current_country == :th
                             charge_info.authorize_uri
                           end
      end

      private

      def set_status
        @status_table.dig(@current_country, charge_info[:status].to_sym)
      end

      def description
        desc_source = if @current_country == :th
                        charge_info.description
                      else
                        charge_info.dig(:custom_data)
                      end
        @description ||= desc_source ? JSON.parse(desc_source, symbolize_names: true) : nil
      end

      def parse_card_num(card_num_source)
        card_num_source.insert(4, ' ').insert(9, ' ').insert(14, ' ') if card_num_source&.length == 16
        card_num_source
      end
    end
  end
end

#== omise
# {
#                         "object" => "charge",
#                             "id" => "chrg_test_5jy5gg4p72o5iy04ijm",
#                       "location" => "/charges/chrg_test_5jy5gg4p72o5iy04ijm",
#                         "amount" => 124600,
#                            "net" => 119734,
#                            "fee" => 4548,
#                        "fee_vat" => 318,
#                       "interest" => 0,
#                   "interest_vat" => 0,
#                 "funding_amount" => 124600,
#                "refunded_amount" => 0,
#                     "authorized" => true,
#                     "capturable" => false,
#                        "capture" => true,
#                     "disputable" => true,
#                       "livemode" => false,
#                     "refundable" => true,
#                       "reversed" => false,
#                     "reversible" => false,
#                         "voided" => false,
#                           "paid" => true,
#                        "expired" => false,
#                   "platform_fee" => {
#              "fixed" => nil,
#             "amount" => nil,
#         "percentage" => nil
#     },
#                       "currency" => "THB",
#               "funding_currency" => "THB",
#                             "ip" => nil,
#                        "refunds" => {
#           "object" => "list",
#             "data" => [],
#            "limit" => 20,
#           "offset" => 0,
#            "total" => 0,
#         "location" => "/charges/chrg_test_5jy5gg4p72o5iy04ijm/refunds",
#            "order" => "chronological",
#             "from" => "1970-01-01T00:00:00Z",
#               "to" => "2020-05-31T07:25:47Z"
#     },
#                           "link" => nil,
#                    "description" => "{\"user\":399,\"cart\":18828,\"order\":4922}",
#                       "metadata" => {},
#                           "card" => {
#                      "object" => "card",
#                          "id" => "card_test_5jy5gf89ii5f08operi",
#                    "livemode" => false,
#                    "location" => nil,
#                     "deleted" => false,
#                     "street1" => nil,
#                     "street2" => nil,
#                        "city" => "",
#                       "state" => nil,
#                "phone_number" => nil,
#                 "postal_code" => "",
#                     "country" => "th",
#                   "financing" => "credit",
#                        "bank" => "SAMPLE BANK",
#                       "brand" => "Visa",
#                 "fingerprint" => "KWmH0q9OFFdkKKo9YzkBcMC0sXdRBmPcQtZ2m0dZHlQ=",
#                "first_digits" => nil,
#                 "last_digits" => "4242",
#                        "name" => "abc",
#            "expiration_month" => 12,
#             "expiration_year" => 2023,
#         "security_code_check" => true,
#                  "created_at" => "2020-05-21T09:01:10Z"
#     },
#                         "source" => nil,
#                       "schedule" => nil,
#                       "customer" => nil,
#                        "dispute" => nil,
#                    "transaction" => "trxn_test_5jy5ggqm45wzbert9jz",
#                   "failure_code" => nil,
#                "failure_message" => nil,
#                         "status" => "successful",
#                  "authorize_uri" => "https://api.omise.co/payments/paym_test_5jy5gg4rngg4nuoc9oo/authorize",
#                     "return_uri" => "http://localhost:3000/ko/payments/check/charge/4899",
#                     "created_at" => "2020-05-21T09:01:14Z",
#                        "paid_at" => "2020-05-21T09:01:17Z",
#                     "expires_at" => "2020-05-28T09:01:14Z",
#                     "expired_at" => "2020-05-28T09:01:14Z",
#                    "reversed_at" => nil,
#     "zero_interest_installments" => false
# }
#==


#== iamport
# {
#                  "amount" => 3989,
#               "apply_num" => "49824223",
#               "bank_code" => nil,
#               "bank_name" => nil,
#              "buyer_addr" => nil,
#             "buyer_email" => "titiwood@nate.com",
#              "buyer_name" => "이준호",
#          "buyer_postcode" => nil,
#               "buyer_tel" => nil,
#           "cancel_amount" => 0,
#          "cancel_history" => [],
#           "cancel_reason" => nil,
#     "cancel_receipt_urls" => [],
#            "cancelled_at" => 0,
#               "card_code" => "365",
#               "card_name" => "삼성카드",
#             "card_number" => "625817*********6",
#              "card_quota" => 0,
#               "card_type" => 0,
#     "cash_receipt_issued" => false,
#                 "channel" => "pc",
#                "currency" => "KRW",
#             "custom_data" => nil,
#            "customer_uid" => nil,
#      "customer_uid_usage" => nil,
#                  "escrow" => false,
#             "fail_reason" => nil,
#               "failed_at" => 0,
#                 "imp_uid" => "imp_700963063074",
#            "merchant_uid" => "chrg_ko-20200530073242-1dc59253",
#                    "name" => "가나다 등 1개",
#                 "paid_at" => 1590823998,
#              "pay_method" => "card",
#                   "pg_id" => "INIpayTest",
#             "pg_provider" => "html5_inicis",
#                  "pg_tid" => "StdpayCARDINIpayTest20200530163318254902",
#             "receipt_url" => "https://iniweb.inicis.com/DefaultWebApp/mall/cr/cm/mCmReceipt_head.jsp?noTid=StdpayCARDINIpayTest20200530163318254902&noMethod=1",
#              "started_at" => 1590823963,
#                  "status" => "paid",
#              "user_agent" => "sorry_not_supported_anymore",
#              "vbank_code" => nil,
#              "vbank_date" => 0,
#            "vbank_holder" => nil,
#         "vbank_issued_at" => 0,
#              "vbank_name" => nil,
#               "vbank_num" => nil
# }
#==

#== iamport cancelled
# {
#                  :amount => 3989,
#               :apply_num => "48681948",
#               :bank_code => nil,
#               :bank_name => nil,
#              :buyer_addr => nil,
#             :buyer_email => "titiwood@nate.com",
#              :buyer_name => "이준호",
#          :buyer_postcode => nil,
#               :buyer_tel => nil,
#           :cancel_amount => 3989,
#          :cancel_history => [
#         [0] {
#                   :pg_tid => "StdpayCARDINIpayTest20200603145505076602",
#                   :amount => 3989,
#             :cancelled_at => 1591166901,
#                   :reason => "취소요청api",
#              :receipt_url => "https://iniweb.inicis.com/DefaultWebApp/mall/cr/cm/mCmReceipt_head.jsp?noTid=StdpayCARDINIpayTest20200603145505076602&noMethod=1"
#         }
#     ],
#           :cancel_reason => "취소요청api",
#     :cancel_receipt_urls => [
#         [0] "https://iniweb.inicis.com/DefaultWebApp/mall/cr/cm/mCmReceipt_head.jsp?noTid=StdpayCARDINIpayTest20200603145505076602&noMethod=1"
#     ],
#            :cancelled_at => 1591166901,
#               :card_code => "365",
#               :card_name => "삼성카드",
#             :card_number => "625817*********6",
#              :card_quota => 0,
#               :card_type => 0,
#     :cash_receipt_issued => false,
#                 :channel => "pc",
#                :currency => "KRW",
#             :custom_data => "{\"user\":399,\"cart\":18870,\"order\":5002}",
#            :customer_uid => nil,
#      :customer_uid_usage => nil,
#                  :escrow => false,
#             :fail_reason => nil,
#               :failed_at => 0,
#                 :imp_uid => "imp_294655672996",
#            :merchant_uid => "chrg_ko-20200603055415-9872d0c9",
#                    :name => "가나다 등 1개",
#                 :paid_at => 1591163705,
#              :pay_method => "card",
#                   :pg_id => "INIpayTest",
#             :pg_provider => "html5_inicis",
#                  :pg_tid => "StdpayCARDINIpayTest20200603145505076602",
#             :receipt_url => "https://iniweb.inicis.com/DefaultWebApp/mall/cr/cm/mCmReceipt_head.jsp?noTid=StdpayCARDINIpayTest20200603145505076602&noMethod=1",
#              :started_at => 1591163655,
#                  :status => "cancelled",
#              :user_agent => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.61 Safari/537.36",
#              :vbank_code => nil,
#              :vbank_date => 0,
#            :vbank_holder => nil,
#         :vbank_issued_at => 0,
#              :vbank_name => nil,
#               :vbank_num => nil
# }
