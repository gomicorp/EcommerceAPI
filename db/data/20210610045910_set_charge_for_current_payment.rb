class SetChargeForCurrentPayment < ActiveRecord::Migration[6.0]
  def up
    Payment.where.not(charge_id: [nil, 0]).each do |payment|
      pg_name = payment.pay_method
      pg_id = payment.charge_id
      now = DateTime.now
      Payment::Charge.create(payment: payment, pg_name: pg_name, external_charge_id: pg_id, status: Payment::Charge.statuses[:pending], created_at: payment.created_at)
      Payment::Charge.create(payment: payment, pg_name: pg_name, external_charge_id: pg_id, status: Payment::Charge.statuses[:paid], created_at: payment.paid_at)  if payment.paid

      # paid가 nil인 주문이 있어서 마이그레이션이 불가한 것을 고치기 위한 코드. 프로덕션 환경에서 해당하는 레코드는 1건입니다. id: 4379
      payment.update(paid: false, expire_at: (payment.created_at + 30.minutes)) if payment.paid.nil?
      Payment::Charge.create(payment: payment, pg_name: pg_name, external_charge_id: pg_id, status: Payment::Charge.statuses[:expired], created_at: payment.expire_at)  if !payment.paid && payment.expire_at < now
      Payment::Charge.create(payment: payment, pg_name: pg_name, external_charge_id: pg_id, status: Payment::Charge.statuses[:refunded], created_at: Payment.last.order_info&.items&.first&.cancelled_tag&.created_at || payment.updated_at)  if payment.paid && payment.cancelled
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
