class ProductItem < ApplicationRecord
  belongs_to :item_group, class_name: 'ProductItemGroup', foreign_key: :item_group_id
  has_many :product_item_product_options
  has_many :options, class_name: 'ProductOption', through: :product_item_product_options
  has_many :adjustment_product_items
  has_one :zohomap, as: :zohoable

  def exports_quantity(from=nil, to=nil, channel=nil)
    if from == nil && to == nil && channel
      return calculate_export_quantity_channel(self, channel)
    elsif from == nil && to == nil && channel == nil
      return calculate_export_quantity(self)
    elsif from && to && channel == nil
      return calculate_export_quantity_date(self, from, to)
    else
      return calculate_export_quantity_date_channel(self, from, to, channel)
    end
  end

  def channel_filter(channel, query_channel)
    if query_channel == 'All'
      return true
    else
      return channel == query_channel
    end
  end

  def calculate_export_quantity_date_channel(object, from, to, channel)
    quantity = 0
    object.adjustment_product_items.each do |value|
      if value.adjustment["exported_time"] >= Date.strptime(from, '%Y-%m-%d') && 
        value.adjustment["exported_time"] <= Date.strptime(to, '%Y-%m-%d') && 
        channel_filter(value.adjustment["channel"], channel) &&
        value.adjustment["reason"] == "Xuất hàng (Orders)"
        quantity += value["quantity"]
      end
    end
    return quantity
  end

  def calculate_export_quantity_date(object, from, to)
    quantity = 0
    object.adjustment_product_items.each do |value|
      if value.adjustment["exported_time"] >= Date.strptime(from, '%Y-%m-%d') && 
        value.adjustment["exported_time"] <= Date.strptime(to, '%Y-%m-%d') && 
        value.adjustment["reason"] == "Xuất hàng (Orders)"
        quantity += value["quantity"]
      end
    end
    return quantity
  end

  def calculate_export_quantity_channel(object, channel)
    quantity = 0
    object.adjustment_product_items.each do |value|
      if channel_filter(value.adjustment["channel"], channel) &&
        value.adjustment["reason"] == "Xuất hàng (Orders)"
        quantity += value["quantity"]
      end
    end
    return quantity
  end

  def calculate_export_quantity(object)
    quantity = 0
    object.adjustment_product_items.each do |value|
      if value.adjustment["reason"] == "Xuất hàng (Orders)"
        quantity += value["quantity"]
      end
    end
    return quantity
  end
end
