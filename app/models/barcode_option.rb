class BarcodeOption < ApplicationRecord
  belongs_to :barcode, dependent: :destroy
  belongs_to :product_option, dependent: :destroy

  scope :barcode_ids_for, ->(*option_ids) { where(product_option_id: option_ids).duplicate_barcode_ids(option_ids.size) }
  scope :duplicate_barcode_ids, ->(length) { group(:barcode_id).count.select { |a,b| a if b == length }.keys }
end
