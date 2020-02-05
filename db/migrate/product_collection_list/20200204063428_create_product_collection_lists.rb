class CreateProductCollectionLists < ActiveRecord::Migration[6.0]
  include ViewTableBuilder

  # CREATE VIEW #{table_name} AS
  # SELECT
  #   elem.product_item_id AS item_id,
  #   elem.product_collection_id AS collection_id,
  #   COUNT(*) as unit_count
  # FROM product_collection_elements elem
  # GROUP BY
  #   elem.product_item_id,
  #   elem.product_collection_id;
  def up
    create_view :product_collection_lists do |t|
      t.from :product_collection_elements, :elem

      t.group_with source_table: :elem, source_column: :product_item_id
      t.group_with source_table: :elem, source_column: :product_collection_id

      t.column :item_id,        source_table: :elem, source_column: :product_item_id
      t.column :collection_id,  source_table: :elem, source_column: :product_collection_id
      t.column :unit_count,     sql: 'COUNT(*)'
    end
  end

  def down
    drop_view :product_collection_lists
  end
end
