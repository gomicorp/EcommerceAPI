module Store
  module Paying
    class KoreaPg
      attr_reader :params
      attr_reader :imp
      attr_reader :error_class

      def initialize(params: nil, charge_id: nil)
        @params = params unless params.nil?
        @charge_id = charge_id unless charge_id.nil?
        @imp = Iamport
        @token = get_token

        @api_key = credentials.dig(:api_key)
        @api_secret = credentials.dig(:api_secret)
        @error_class = nil
      end

      def prepared(charge_id = @charge_id)
        @imp.prepared charge_id
      end

      def checkout(**args)
        cart = args.dig(:cart)
        charge_id = args.dig(:charge_id)
        imp.prepare(merchant_uid: charge_id, amount: cart.final_price)
      end

      def charge_object(charge_id)
        @charge_object ||= JSON.parse(imp.find(charge_id).body, symbolize_names: true).dig(:response)
      end

      def refund(charge_id, **args)
        charge = charge_object(charge_id)

        # charge 상태가 pending이거나 failed이면 실 결제가 이루어지지 않은 것으로,
        # refund 요청을 만들지 않고 넘어갑니다.
        return false unless charge.dig(:status) == 'paid'

        amount = args.dig(:amount)
        refund_info = {
          imp_uid: charge_object(charge_id).dig(:imp_uid),
          merchant_uid: charge_object(charge_id).dig(:merchant_uid),
          amount: amount,
          checksum: charge.dig(:amount)
        }
        @imp.cancel(refund_info)
      end

      private

      # def event_object(event_id)
      #   Omise::Event.retrieve(event_id)
      # end

      def credentials
        Rails.application.credentials.dig(Rails.env.to_sym, :iamport).freeze
      end

      def get_token
        imp.token
      end

    end
  end
end
