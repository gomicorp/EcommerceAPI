module HistoricalRecordable
  extend ActiveSupport::Concern

  def included(base)
    return if base.name.in?(exclude_historical_models)

    base.send :has_paper_trail
    base.send :extend, ClassMethods
  end

  module ClassMethods
    def version_at(timestamp)
      paper_trail.version_at timestamp
    end
  end

  def is_historical?
    respond_to? :paper_trail
  end

  def historical_associations
    associations.select do |association|
      association[:klass].new.is_historical?
    end
  end

  def self.exclude_historical_models
    %w[ProductItemBarcode]
  end
end
