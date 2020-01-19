module ApplicationHelper
  def currency_format(num, unit: nil, format: '%n %u', precision: 0, **opt)
    number_to_currency num, unit: unit, format: format, precision: precision, **opt
  end

  def unit_format(num, unit: 'EA', format: '%n %u', precision: 0, **opt)
    number_to_currency num, unit: unit, format: format, precision: precision, **opt
  end
end
