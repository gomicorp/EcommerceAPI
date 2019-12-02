class BarcodeGroup
  attr_reader :id, :product_id
  attr_reader :option_ids, :barcode_ids
  attr_reader :product

  def initialize(product, option_ids = [], barcode_ids = [])
    @id = option_ids
    @product_id = product.id
    @option_ids = option_ids
    @barcode_ids = barcode_ids
    @product = product
  end

  def barcodes
    @barcodes ||= Barcode.where(id: barcode_ids)
  end

  def product_options
    @product_options ||= ProductOption.where(id: option_ids)
  end

  def name
    @name ||= product_options.pluck(:name).join(', ').presence || fake_name
  end

  def alive_barcode_count
    @alive_barcode_count ||= barcodes.alive.count
  end

  def additional_price
    @additional_price ||= product_options.sum(:additional_price)
  end

  def price_mark
    additional_price >= 0 ? '+' : '-'
  end

  def inspect
    "#<BarcodeGroup(virtual) #{info_inspect.join(', ')}>"
  end

  def info
    {
      id: id,
      product_id: product_id,
      name: id.any? ? name : fake_name,
      barcode_count: barcode_ids.size,
      alive_barcode_count: @alive_barcode_count,
      additional_price: @additional_price
    }
  end

  def info_inspect
    info.map { |k, v| "#{k}: #{v.inspect}" }
  end

  def fake_name
    'Not exists.'
  end
end
