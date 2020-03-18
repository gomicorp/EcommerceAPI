class ProductTimeMachine < ApplicationTimeMachine
  def version_at(timestamp)
    super(timestamp) do |product|
      product = product.version_at(timestamp)
      product.options = product.options.map do |option|
        option.version_at(timestamp)
      end
      product.default_option = product.default_option
    end
  end
end
