include HaravanApiHelper
include HaravanApiHelper::Order

ApplicationRecord.transaction do
  records = self.get_order_by_period('2020-08-01T00:00:00.000Z', '2020-08-02T23:59:59.999Z')

  records.each do |record|
    HaravanOrderInfo.create(haravan_order_id: record['id'],
                            total_price: record['total_price'],
                            ordered_at: record['created_at'])
  end
end
