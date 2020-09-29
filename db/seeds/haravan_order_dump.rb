extend Haravan::ApiService::HaravanOrder
extend Haravan::ApiService

ApplicationRecord.transaction do
  records = self.get_order_by_period('2020-08-13T07:00:00.000Z', '2020-08-20T06:59:59.999Z')

  records.each do |record|
    ship_fee = 0
    record['shipping_lines'].each do |line|
      ship_fee += line['price']
    end

    paid_at = nil
    if record['gateway'] == "Thanh toán khi giao hàng (COD)"
      paid_at = record['fulfillments'][0]['cod_paid_date'] if record['fulfillments'].any?
    else
      paid_at = record['created_at']
    end

    order_info = HaravanOrderInfo.find_or_create_by(haravan_order_id: record['id'])
    order_info.update(total_price: record['total_price'],
                      ordered_at: record['created_at'],
                      pay_method: record['gateway'],
                      channel: record['source'],
                      paid_at: paid_at,
                      order_status: record['financial_status'],
                      ship_fee: ship_fee)
  end
end
