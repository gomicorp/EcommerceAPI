module TimeMachine
  class VersionedRecords
    attr_reader :record

    def initialize(record)
      @record = record
      all
    end

    def all
      @all ||= collect_all
    end

    private

    def collect_all
      versioned_record = record
      versioned_records = []

      while versioned_record
        versioned_records << versioned_record
        versioned_record = versioned_record.previous_version
      end

      versioned_records
    end
  end
end
