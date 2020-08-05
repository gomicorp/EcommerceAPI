# == Schema Information
#
# Table name: barcode_options
#
#  id                :bigint           not null, primary key
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  barcode_id        :bigint
#  product_option_id :bigint
#
# Indexes
#
#  index_barcode_options_on_barcode_id         (barcode_id)
#  index_barcode_options_on_product_option_id  (product_option_id)
#
# Foreign Keys
#
#  fk_rails_...  (barcode_id => barcodes.id)
#  fk_rails_...  (product_option_id => product_options.id)
#
class BarcodeOption < ApplicationRecord
  belongs_to :barcode, dependent: :destroy
  belongs_to :product_option, dependent: :destroy

  scope :barcode_ids_for, ->(*option_ids) { where(product_option_id: option_ids).duplicate_barcode_ids(option_ids.size) }
  scope :duplicate_barcode_ids, ->(length) { group(:barcode_id).count.select { |a,b| a if b == length }.keys }
end
