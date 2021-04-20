class UpdateProductCollectionLists < ActiveRecord::Migration[6.0]
  include ViewTableBuilder

  # ALTER VIEW product_collection_lists AS
  # SELECT
  #   elem.product_item_id AS item_id,
  #   elem.product_collection_id AS collection_id,
  #   COUNT(*) AS unit_count
  # FROM
  #   product_collection_elements elem
  # INNER JOIN
  #  product_items
  # ON product_items.id = elem.product_item_id
  # AND product_items.deleted_at IS NULL
  # WHERE
  #  elem.deleted_at IS NULL
  # AND product_items.deleted_at IS NULL
  # GROUP BY
  #   elem.product_item_id,
  #   elem.product_collection_id
  def up
    update_view :product_collection_lists do |t|
      t.from :product_collection_elements, :elem
      t.inner_join :product_items,
                   [
                     equal({ table: :product_items, column: :id }, { table: :elem, column: :product_item_id }),
                     null( table: :product_items, column: :deleted_at )
                   ]

      t.group_with source_table: :elem, source_column: :product_item_id
      t.group_with source_table: :elem, source_column: :product_collection_id

      t.column :item_id,        source_table: :elem, source_column: :product_item_id
      t.column :collection_id,  source_table: :elem, source_column: :product_collection_id
      t.column :unit_count,     sql: 'COUNT(*)'

      t.where null(table: :elem, column: :deleted_at)
      t.where null(table: :product_items, column: :deleted_at)
    end
  end

  # CREATE VIEW #{table_name} AS
  # SELECT
  #   elem.product_item_id AS item_id,
  #   elem.product_collection_id AS collection_id,
  #   COUNT(*) as unit_count
  # FROM product_collection_elements elem
  # GROUP BY
  #   elem.product_item_id,
  #   elem.product_collection_id;
  def down
    update_view :product_collection_lists do |t|
      t.from :product_collection_elements, :elem

      t.group_with source_table: :elem, source_column: :product_item_id
      t.group_with source_table: :elem, source_column: :product_collection_id

      t.column :item_id,        source_table: :elem, source_column: :product_item_id
      t.column :collection_id,  source_table: :elem, source_column: :product_collection_id
      t.column :unit_count,     sql: 'COUNT(*)'
    end
  end
end
