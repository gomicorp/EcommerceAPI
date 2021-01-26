class MigrateProductCollectionFromOriginalLogic < ActiveRecord::Migration[6.0]
  def up
    ApplicationRecord.country_context_with 'global' do
      PaperTrail.request(enabled: false) do
        ProductCollection.global.each do |product_collection|
          active_by_original_logic = product_collection.items.where(active: false).empty?
          product_collection.update(active: true) if active_by_original_logic
        end
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
