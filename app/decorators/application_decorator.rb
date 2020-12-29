require_relative './concerns/data_field_collectable'

class ApplicationDecorator < Draper::Decorator
  include DataFieldCollectable
  # decorates_finders

  def self.collection_decorator_class
    PaginatingDecorator
  end
end
