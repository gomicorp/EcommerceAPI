module Gomisa
  module ProductItemGroupService
    module ProductItemParsable
      private

      def bulk_save_product_items(item_group)
        item_bulk_params.map do |item_params|
          save_product_item(item_params, item_group)
        end
      end

      def save_product_item(item_params, item_group)
        id_or_nil = item_params.delete(:id)
        item = item_group.items.find_or_initialize_by(id: id_or_nil)
        item.update! item_params
        item
      end

      protected

      def item_bulk_params
        params.require(:product_item).map! do |item_param|
          item_param.permit(*product_item_permits)
        end
      end

      def product_item_permits
        %i[id name serial_number cost_price selling_price]
      end
    end


    module ProductAttributeParsable
      private

      def bulk_save_attributes(item_group = nil)
        attribute_bulk_params.each do |attribute_params|
          product_attribute = save_product_attribute(attribute_params)

          if product_attribute
            attribute_params[:option_names]
                .to_s
                .split(',')
                .map { |name| { name: name.strip } }
                .map { |option_params| product_attribute.options.find_or_create_by(option_params) }
                .tap { |options| (product_attribute.options.to_a - options).each(&:destroy) }
          end

          append_attribute_to_item_group(item_group, product_attribute) if item_group
        end
      end

      def save_product_attribute(attribute_params)
        id_or_nil = attribute_params.delete(:id)
        ProductAttribute.find_or_initialize_by(id: id_or_nil).tap do |attribute|
          attribute.assign_attributes attribute_params.as_json.slice('name')
          attribute.save!
        end
      end

      protected

      def attribute_bulk_params
        params.require(:product_attribute).map! do |attribute|
          attribute.permit(:id, :name, :option_names)
        end
      end

      def append_attribute_to_item_group(item_group, attribute)
        return if item_group.product_attributes.exists? attribute.id

        item_group.product_attributes << attribute
      end
    end


    class Saver
      include ProductItemParsable
      include ProductAttributeParsable
      attr_reader :params
      attr_reader :product_item_group

      def initialize(params)
        @params = params
        @product_item_group = assign_product_item_group
      end

      def save
        ActiveRecord::Base.transaction do
          product_item_group.save!
          bulk_save_product_items product_item_group
          bulk_save_attributes product_item_group
        end
      end

      private

      def assign_product_item_group
        if update_sequence?
          ProductItemGroup.find(params[:id]).tap { |group| group.assign_attributes item_group_params }
        else
          ProductItemGroup.new item_group_params
        end
      end

      protected

      def create_sequence?
        !update_sequence?
      end

      def update_sequence?
        params[:id].present?
      end

      def item_group_params
        params.require(:product_item_group).permit(:name, :brand_id)
      end
    end
  end
end
