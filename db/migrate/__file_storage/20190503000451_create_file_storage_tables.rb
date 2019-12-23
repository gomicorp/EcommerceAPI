class CreateFileStorageTables < ActiveRecord::Migration[5.2]
  def change
    create_table :file_storage_attachments do |t|
      # core
      t.string :name, null: false
      t.references :record, null: false, polymorphic: true, index: false

      # feature
      # 1. save info
      t.integer :location, null: false, default: 0 # enum system, localhost, amazone, google, ...
      t.string :namespace, null: false, default: ''

      # 2. file info
      t.string :original_filename
      t.string :filename
      t.string :filepath

      t.timestamps
    end
  end
end
