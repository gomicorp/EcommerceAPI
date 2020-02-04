class CreateProductCollectionLists < ActiveRecord::Migration[6.0]
  def table_name
    'product_collection_lists'
  end

  def up
    execute <<~SQL
      CREATE VIEW #{table_name} AS
      SELECT
        product_item_id AS item_id,
        product_collection_id AS collection_id,
        COUNT(*) as unit_count
      FROM product_collection_elements elem
      GROUP BY
        elem.product_item_id,
        elem.product_collection_id;
    SQL
  end

  def down
    execute <<~SQL
      DROP VIEW #{table_name}
    SQL
  end
end
