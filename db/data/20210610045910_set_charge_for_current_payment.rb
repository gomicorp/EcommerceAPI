class SetChargeForCurrentPayment < ActiveRecord::Migration[6.0]
  # omise_payment = pay_method가 card인 payment
  #   charge id가 0이면 manual order info
  #   charge id
  def up
    init_omise_api
    # paid가 nil인 주문이 있어서 마이그레이션이 불가한 것을 고치기 위한 코드. 프로덕션 환경에서 해당하는 레코드는 1건입니다. id: 4379
    Payment.where(paid: nil).update_all(paid: false)

    # omise로 결제된 payment들을 가지고 옵니다.
    omise_payment = Payment.where(pay_method: 'omise').where.not(charge_id: [nil, '0'])
    total_count = omise_payment.count
    ap "#{total_count} payment will be processed."
    pending_msg = '  Create the pending charge.'.to_sym
    paid_msg = '  Create the paid charge.'.to_sym
    refund_msg = '  Create the refunded charge.'.to_sym
    expired_msg = '  Create the expired charge.'.to_sym
    ApplicationRecord.transaction do
      omise_payment.each_with_index do |payment, index|
        ap "Payment(id: #{payment.id}) is being processed.. [#{index} / #{total_count}]"
        # 필요한 데이터들을 준비합니다.
        pg_name = payment.pay_method
        pg_id = payment.charge_id
        # 하나의 payment에 따른 모든 charge의 공동 속성
        common_charge_attributes = {
          payment: payment,
          pg_name: pg_name,
          external_charge_id: pg_id
        }
        # omise에서 charge를 불러와서 소스를 만들고, 그게 안되면 다른 데이터로 소스를 만듭니다.
        statement_resources = fetch_statement(payment, pg_id)

        # pending 상태의 charge가 가지는 statement를 구성합니다.
        pending_statement_keys = [:amount, :pay_request_url, :request_url_expire_time, :card]
        pending_statement = statement_resources.clone.keep_if { |k, _| pending_statement_keys.include?(k) }.to_json

        # 데이터들을 모아 pending 상태의 charge를 만듭니다.
        Payment::Charge.create(
          **common_charge_attributes,
          status: Payment::Charge.statuses[:pending],
          created_at: payment.created_at,
          statement: pending_statement
        )
        ap pending_msg

        # 결제가 완료된 payment이면, paid상태의 charge를 생성합니다.
        if payment.paid
          paid_statement_keys = [:amount, :card]
          paid_statement = statement_resources.clone.keep_if { |k, _| paid_statement_keys.include?(k) }.to_json
          Payment::Charge.create(
            **common_charge_attributes,
            status: Payment::Charge.statuses[:paid],
            created_at: payment.paid_at,
            statement: paid_statement
          )
          ap paid_msg
        end

        # 결제가 완료되지 않고 expire 되었으면, expired 상태의 charge를 생성합니다.
        # exire_at이 없는 주문은 정상 주문이 아니므로 마찬가지로 expired시킵니다.
        if !payment.paid && (payment.expire_at.nil? || payment.expire_at < DateTime.now)
          Payment::Charge.create(
            **common_charge_attributes,
            status: Payment::Charge.statuses[:expired],
            created_at: payment.expire_at
          )
          ap expired_msg
        end

        # 결제가 완료 되었지만 refund되었으면, refunded 상태의 charge를 생성합니다.
        if payment.paid && payment.cancelled
          refund_log = payment.status_logs.where(code: Payment.statuses['refund_complete']).last
          if refund_log
            refunded_statement_keys = [:amount]
            refunded_statement = statement_resources.clone.keep_if { |k, _| refunded_statement_keys.include?(k) }.to_json
            Payment::Charge.create(
              **common_charge_attributes,
              status: Payment::Charge.statuses[:refunded],
              created_at: refund_log.created_at,
              statement: refunded_statement
            )
          end
          ap refund_msg
        end
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  def fetch_statement(payment, pg_id, tried=1)
    begin
      omise_charge = get_omise_charge(pg_id)
      build_statement_hash_from(omise_charge)
    rescue Omise::Error => e
      raise e if e.code != 'not_found'
      {
        amount: payment.amount,
        pay_request_url: 'staging.test.charge.url',
        request_url_expire_time: 30.minutes,
        card: {
          card_name: 'visa',
          year: '22',
          month: '11',
          id: 'test_card_id',
          card_number: '**** **** **** ****',
          name: 'test_name'
        }
      }
    rescue NoMethodError => e
      wait_cool_down(tried)
      fetch_statement(payment, pg_id, (tried + 1))
    end
  end

  def build_statement_hash_from(omise_charge)
    card_info = omise_charge.card.as_json
    {
      amount: omise_charge.amount,
      pay_request_url: omise_charge.authorize_uri,
      request_url_expire_time: 30.minutes,
      card: {
        card_name: card_info.dig('brand'),
        year: card_info.dig('expiration_year'),
        month: card_info.dig('expiration_month'),
        id: card_info.dig('id'),
        card_number: [card_info.dig('first_digits') || '****', ' **** **** ', card_info.dig('last_digits') || '****'].join,
        name: card_info.dig('name')
      }
    }
  end

  def wait_cool_down(tried)
    ap "Omise api seems like tired.."
    spin_particles = [ '⎮', '/', '-', '\\'] * 3
    (tried**2).times do
      spin_particles.each do |particle|
        print "#{particle} \r"
        sleep 0.3
      end
    end
  end

  def get_omise_charge(charge_id)
    Omise::Charge.retrieve(charge_id)
  end

  def init_omise_api
    Omise.secret_api_key = Rails.application.credentials.dig(:omise, :sec_key)
  end
end
