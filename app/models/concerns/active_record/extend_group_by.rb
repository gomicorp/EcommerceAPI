module ActiveRecord
  module ExtendGroupBy
    def self.included(base)
      base.send :extend, ClassMethods
      QueryMethods::WhereChain.include ClassMethods
    end

    class Result
      attr_reader :source
      attr_reader :grouped_value, :counts

      def initialize(klass, source, queries)
        @source = source
        grouped_value = source.keys
        counts = source.values

        @result = grouped_value.zip(counts, queries).map do |key, count, query|
          {
            key => Result::Element.new(count, klass.where(query))
          }
        end
      end

      def fetch(key)
        @result.select { |r| r[key] }.first&.dig(key)
      end

      class Element
        attr_reader :count, :relation

        def initialize(count, relation)
          @count = count
          @relation = relation
        end

        delegate :all, to: :relation
      end
    end

    module ClassMethods
      def grouping_by(*columns)
        hash = group(*columns).count
        # p hash
        value_case = hash.keys
        # p value_case
        queries = case value_case.first
                  when Array
                    [columns].product(value_case).map(&:transpose).map(&:to_h)
                  else
                    columns.product(value_case).map { |k, v| { k => v } }
                  end

        Result.new(self, hash, queries)
      end
    end
  end
end
