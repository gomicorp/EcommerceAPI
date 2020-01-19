module Haravan
  module Core
    module Enumerable
      def each(block, entries)
        for entry in entries do
          block.call(entry)
        end
        entries
      end

      def map(block, entries)
        res = []
        each(
            ->(entry) { res << block.call(entry) },
            entries
        )
        res
      end

      def filter(block, entries)
        res = []
        each(
            ->(entry) { res.push(entry) if block.call(entry) },
            entries
        )
        res
      end

      def reduce(block, acc, entries)
        unless entries
          a = acc.shift
          entries = acc.dup
          acc = a
        end

        each(
            ->(entry) { acc = block.call(acc, entry) },
            entries
        )

        acc
      end
    end
  end
end
