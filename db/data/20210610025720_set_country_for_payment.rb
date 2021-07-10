class SetCountryForPayment < ActiveRecord::Migration[6.0]
  def up
    all_payment = Payment.all
    count = all_payment.count
    all_payment.each_with_index do |payment, index|
      if payment.order_info.nil?
        payment.destroy!
        ap "payment(id: #{payment.id}) is deleted. [ #{index} / #{count} ]"
        next
      end
      payment.update(country: payment.order_info.country)
      print "payment(id: #{payment.id}) is updated. [ #{index} / #{count} ]                      \r"
    end
    puts ''
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
