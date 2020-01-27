module Haravan
  module Api
    class Record
      attr_reader :data if Rails.env == 'development'

      private

      def set_if_respond(k, v)
        send("#{k}=", v) if respond_to?("#{k}=")
      end

      public

      def initialize(**data)
        @data = data if Rails.env == 'development'
        data.each do |k, v|
          case v
          when Hash, Array
            set_if_respond("_#{k}", v)
          when String
            if k.to_s[/_at$/]
              v = v.in_time_zone rescue v
            end
            set_if_respond(k, v)
          else
            set_if_respond(k, v)
          end
        end
      end

      def cached(&block)
        block_object_id = block_given? ? block.object_id : nil
        self.class.storage[self.class.table_name][block_object_id]
      end

      class << self
        include PageCollectable, Core::Timer
        attr_accessor :table_name, :root_key, :attributes

        def schema=(attrs)
          attrs.each do |attr|
            attr_accessor attr.to_sym
          end
          @attributes = attrs
        end

        def has_many(key, class_name:, data_from:)
          class_eval <<-CODE
            def #{key}
              @#{key} ||= ::#{class_name}.map_collection(#{data_from})
            end
          CODE
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

        def ugly_search_by(step: 100, recursive_limit: 200, &block)
          collection = collect_page(
              page: 1,
              step: step,
              direction: 1,
              before_page: 0,
              recursive_limit: recursive_limit,
              &block
          )
          map_collection collection.uniq(&:id)
        end

        def search_by(**clause)
          map_collection collect_page_in_row(**clause)
        end

        def count_by(**clause)
          fetcher.fetch("#{table_name}/count.json", clause)[:count]
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
          fetcher.fetch("#{table_name}.json", clause.merge(fields: @attributes.map {|attr| attr.to_s.gsub(/^_/, '')}.join(',')))
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
