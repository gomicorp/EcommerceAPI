require 'omise'
module Store
  module Paying
    class ThaiPg
      attr_reader :params # should only has :omiseToken for checkout
      attr_reader :charge_id
      attr_reader :error_class

      def initialize(params: nil, charge_id: nil)
        @params = params unless params.nil?
        @charge_id = charge_id unless charge_id.nil?

        @pub_key = credentials.dig(:pub_key)
        @secret_key = credentials.dig(:sec_key)

        @error_class = Omise::Error

        set_omise
      end

      def checkout(**args)
        cart = args.dig(:cart)
        order = args.dig(:order)
        description = {user: cart&.user_id,
                       cart: cart&.id,
                       order: order&.id}
        charge = Omise::Charge.create(
          amount: omise_type_amount(args.dig(:amount)),
          currency: 'thb',
          description: description.to_json,
          card: params[:omiseToken],
          return_uri: args.dig(:return_uri)
        )
      end

      def refund(charge_id, **args)
        charge = charge_object(charge_id)
        # omise의 charge 상태가 pending이거나 failed이면 실 결제가 이루어지지 않은 것으로,
        # refund 요청을 만들지 않고 넘어갑니다.
        charge.refunds.create(amount: omise_type_amount(args.dig(:amount))) unless %w[pending failed].include? charge.status
      end

      def charge_object(charge_id)
        Omise::Charge.retrieve(charge_id)
      end

      private

      def event_object(event_id)
        Omise::Event.retrieve(event_id)
      end

      def credentials
        Rails.application.credentials.dig(Rails.env.to_sym, :omise).freeze
      end

      def set_omise
        Omise.api_key = @secret_key
      end

      def omise_type_amount(amount)
        amount.to_i * 100
      end
    end
  end
end
