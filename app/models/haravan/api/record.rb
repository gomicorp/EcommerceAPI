module Haravan
  module Api
    class Record
      attr_reader :data

      def initialize(**data)
        @data = data
        data.each do |k, v|
          case v
          when Hash, Array
            send("_#{k}=", v)
          when String
            v = v.in_time_zone rescue v
            send("#{k}=", v)
          else
            send("#{k}=", v)
          end
        end
      end

      def cached(&block)
        block_object_id = block_given? ? block.object_id : nil
        self.class.storage[self.class.table_name][block_object_id]
      end

      class << self
        include PageCollectable
        attr_accessor :table_name, :root_key, :attributes

        def schema=(attrs)
          attrs.each do |attr|
            attr_accessor attr.to_sym
          end
          @attributes = attrs
        end

        def storage
          $haravan_api_storage ||= {}
        end

        def all(step: 100, recursive_limit: 200, &block)
          start_at = Time.now
          storage[table_name] ||= {}
          collection = storage[table_name][block.object_id]

          unless collection
            collection = collect_page(
                page: 1,
                step: step,
                direction: 1,
                before_page: 0,
                recursive_limit: recursive_limit,
                &block
            )
            collection = Collection.build(collection.uniq(&:id))
            storage[table_name][block.object_id] = collection
          end

          end_at = Time.now
          diff = (end_at - start_at).to_i
          puts "Diff time: \"#{diff / 60}:#{diff % 60}\""
          puts "Result collection: #{collection.length}"

          collection
        end

        def where(**clause, &block)
          dataset = query_with_root_key(**clause)
          records = filtering_dataset(dataset, ->(data) { new(**data) }, &block)
          map_collection(records)
        end

        def search_by(**clause)
          map_collection collect_page_in_row(**clause)
        end

        def map_collection(records_or_dataset)
          records = if records_or_dataset.first.is_a? Hash
                      records_or_dataset.map { |data| new(**data) }
                    else
                      records_or_dataset
                    end
          Collection.new(records)
        end

        def query_with_root_key(**clause)
          res = query(**clause)
          root_key ? res[root_key.to_sym] : res
        end

        def filtering_dataset(dataset, mapper = nil, &block)
          dataset.map { |data|
            next unless block.call(data) if block_given?
            mapper ? mapper.call(data) : data
          }.compact
        end

        def query(**clause)
          fetcher.fetch("#{table_name}.json", clause)
        end

        def fetcher
          Fetcher.new
        end

        def table_name
          @table_name || to_s.downcase.pluralize
        end

        def table_name=(value)
          @table_name = value
          @root_key ||= value
        end
      end
    end
  end
end
