class AddGomiStandardProductCodeToProductStuff < ActiveRecord::Migration[6.0]
  def up
    update_gspc = ->(gspc_record) { gspc_record.update(gspc: gspc_record.gspc_gen) }

    ApplicationRecord.country_context_with 'global' do
      PaperTrail.request(enabled: false) do

        if Rails.env.development?
          ProductItem.global.each do |item|
            item.serial_number = "#{item.serial_number}--#{item.id}"
            item.name ||= Faker.name
          end
        end

        ProductItem.global.where(gomi_standard_product_code: nil).each(&update_gspc)
        ProductCollection.global.where(gomi_standard_product_code: nil).each(&update_gspc)
      end
    end
  end

  def down
  end
end
