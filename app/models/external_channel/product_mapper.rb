module ExternalChannel
  class ProductMapper < NationRecord
    belongs_to :product, class_name: '::Product'
    belongs_to :channel
  end
end
