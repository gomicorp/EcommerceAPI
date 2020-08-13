module Store
  class CartItemService
    attr_reader :cart, :items

    attr_reader :product_option, :barcodes, :cart_item
    attr_reader :errors

    def initialize(cart, seller_info = nil)
      @cart = cart
      @items = cart.items
      @seller_info = seller_info unless seller_info.nil?
    end

    def add(product_option_id, quantity = 0)
      option = ProductOption.find product_option_id
      addable_status = new_addable?(option, quantity)
      return addable_status unless addable_status

      ActiveRecord::Base.transaction do
        cart_item = items.select do |i|
          seller = i&.item_sold_paper&.seller_info
          i.product_option.id == product_option_id.to_i && seller == @seller_info
        end.first
        unless cart_item
          cart_item ||= items.create(
            cart: cart,
            product_option: option,
            product: option.product
          )
        end

        quantity.times { put_in_barcode!(cart_item, option) }
        cart_item.write_sold_paper(@seller_info) unless @seller_info.nil?
      end

      true
    end

    def plus(product_option_id, quantity = 0)
      option = ProductOption.find product_option_id
      cart_items = items

      @cart_item = cart_items.find_or_create_by(cart: cart, product_option: option, product: option.product)

      addable_status = new_addable?(option, quantity)
      return addable_status unless addable_status

      cart_item.save
      quantity.times { put_in_barcode!(cart_item, option) }
      cart_item.item_sold_paper&.reset_profit
      true
    end

    def minus(product_option_id, quantity = 0)
      option = ProductOption.find product_option_id
      cart_items = items

      @cart_item = cart_items.find_or_create_by(cart: cart, product_option: option, product: option.product)

      removable = removable?(quantity)
      unless removable
        @cart_item.destroy if empty_item?
        return removable
      end

      ActiveRecord::Base.transaction do
        quantity.times do
          take_out_barcode!(@cart_item, option)
        end
        @cart_item.destroy if empty_item?
      end

      true
    end

    def minus_all_item
      items = @cart.items
      ActiveRecord::Base.transaction do
        items.each do |item|
          minus(item.product_option_id, item.option_count)
        end
      end
      true
    end

    def reload
      CartItemService.reload(cart)
    end

    def self.reload(cart)
      new(Cart.find(cart.id))
    end

    def product_stocked_quantity
      barcodes.reload.alive.size
    end

    def item_taken_quantity
      cart_item.option_count.to_i
    end

    def error_messages
      errors&.join(', ')
    end

    private

    def put_in_barcode!(cart_item, option)
      option.bridges.each do |bridge|
        bridge_items(bridge).each do |product_item|
          barcode = product_item.barcodes.alive.first
          CartItemBarcode.create!(cart_item: cart_item, product_item_barcode: barcode)
          barcode.expire!
        end
      end
      cart_item.option_count += 1
      cart_item.save!
    end

    def take_out_barcode!(cart_item, option)
      barcodes = cart_item.product_item_barcodes
      option.bridges.each do |bridge|
        bridge.items.map do |product_item|
          barcode = barcodes.find_by(product_item_id: product_item.id)
          cart_item.cart_item_barcodes.find_by(product_item_barcode_id: barcode.id).destroy!
          barcode.disexpire!
        end
      end
      cart_item.option_count -= 1
      cart_item.save!
    end

    def bridge_items(bridge)
      bridge.connectable_type == 'ProductCollection' ? bridge.connectable.items : [bridge.connectable]
    end

    def new_addable?(option, quantity)
      # Argument error
      return if quantity.nil? || quantity.to_i.zero? || quantity.to_i.negative?

      # Sold out
      unless option.available_quantity >= quantity
        @errors ||= []
        @errors << if option.available_quantity.to_i.zero?
                     'store.add_to_cart_window.error_message.sold_out'
                   else
                     'store.add_to_cart_window.error_message.over_quantity'
                   end
        return false
      end

      true
    end

    def addable?(order_request_quantity = 0)
      addable = !sold_out? && product_stocked_quantity >= order_request_quantity
      unless addable
        @errors ||= []
        if sold_out?
          @errors << 'store.add_to_cart_window.error_message.sold_out'
        elsif !(product_stocked_quantity >= order_request_quantity)
          @errors << 'store.add_to_cart_window.error_message.over_quantity'
        end
      end

      addable
    end

    def sold_out?
      product_stocked_quantity.zero?
    end


    def removable?(remove_request_quantity = 0)
      removable = !empty_item? && item_taken_quantity >= remove_request_quantity
      unless removable
        @errors ||= []
        if empty_item?
          @errors << 'store.add_to_cart_toast.error_message.already_clear'
        elsif !(item_taken_quantity >= remove_request_quantity)
          @errors << 'store.add_to_cart_toast.error_message.too_many_to_remove'
        end
      end

      removable
    end

    def empty_item?
      item_taken_quantity.zero?
    end

    def set_minor_resources(product_option_ids)
      @barcodes = Barcode.options_with(*product_option_ids)
      # @product_option = ProductOption.find(product_option_id)
      @product_option_barcodes = product_option.barcodes.alive
      @cart_item = cart.items.find_or_create_by(
        cart_id: cart.id,
        product_option_id: product_option.id
      )
    end
  end
end
