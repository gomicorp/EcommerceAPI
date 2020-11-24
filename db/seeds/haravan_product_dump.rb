extend Haravan::ApiService::HaravanProduct
extend Haravan::ApiService

ApplicationRecord.transaction do
  records = self.save_haravan_products_with_api('2020-08-13T07:00:00.000Z', '2020-08-20T06:59:59.999Z')
end
