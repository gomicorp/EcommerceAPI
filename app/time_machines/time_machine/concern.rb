module TimeMachine
  module Concern
    def self.included(base)
      base.send :has_paper_trail
      base.send :extend, ClassMethods
    end

    module ClassMethods
      def has_not_paper_trail
        PaperTrail.request.disable_model(self)
      end

      def is_historical?
        PaperTrail.request.enabled_for_model?(self)
      end

      def version_at(timestamp)
        placeholder = 'item_type = :item_type AND created_at > :created_at'
        where(versions: PaperTrail::Version.where(placeholder, item_type: name, created_at: timestamp))
      end
    end


    ## ===== Instance Methods =====

    def is_historical?
      self.class.is_historical?
    end

    def version_at(timestamp)
      paper_trail.version_at(timestamp)
    end

    def previous_version
      paper_trail.previous_version
    end

    def versioned_records
      @versioned_records ||= VersionedRecords.new(self)
    end

    def associated_version_at(timestamp)
      model_name = self.class.name
      time_machine_name = "#{model_name}TimeMachine"
      time_machine = time_machine_name.constantize rescue nil
      time_machine.nil? ? version_at(timestamp) : time_machine.checkout(self, timestamp)
    end

    def historical_associations
      associations.select do |association|
        association[:klass].is_historical?
      end
    end
  end
end
