class ProductOptionTimeMachine < ApplicationTimeMachine
  def version_at(timestamp)
    super(timestamp) do |product_option|
      # product 복원
      product_option.product_page = product_option.product_page.version_at(timestamp)

      # product_item 복원
      product_option.bridges = product_option.bridges.map do |bridge|
        bridge.connectable = bridge.connectable.version_at(timestamp)
        if bridge.connectable_type == 'ProductCollection'
          bridge.connectable.items = bridge.connectable.items.map { |product_item| product_item.version_at(timestamp) }
        end
        bridge
      end
    end
  end
end
