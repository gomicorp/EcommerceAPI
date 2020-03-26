module ViewTableBuilder
  def create_view(table_name)
    @builder = ViewBuilder.new(table_name)
    yield(@builder)
    execute @builder.build_create_query
  end

  def drop_view(table_name)
    @builder = ViewBuilder.new(table_name)
    execute @builder.build_drop_query
  end


  class ViewBuilder
    attr_reader :table_name
    attr_reader :from_stack, :select_stack, :group_by_stack

    def initialize(table_name)
      @table_name = table_name

      @from_stack = []
      @select_stack = []
      @group_by_stack = []
    end

    def from(table, name_as = nil)
      from_stack << compact_join(table, name_as, sep: ' ')
    end

    def column(name, sql: nil, source_table: nil, source_column: nil)
      clause = if sql.presence
                 sql.presence.to_s
               else
                 source_table ||= table_name
                 source_column ||= name

                 "#{source_table}.#{source_column}"
               end

      select clause, name
    end

    def group_with(sql: nil, source_table: nil, source_column: nil)
      clause = if sql.presence
                 sql.presence.to_s
               else
                 source_table ||= table_name
                 source_column ||= :id

                 "#{source_table}.#{source_column}"
               end

      group_by clause
    end

    def select(clause, as)
      return if clause.presence.nil?
      select_stack << compact_join(clause, as, sep: ' AS ')
    end

    def group_by(clause)
      group_by_stack << clause
    end

    def build_create_query
      [
        create_query,
        select_query,
        from_query,
        group_by_query
      ].join("\n")
    end

    def build_drop_query
      drop_query
    end


    private

    def create_query
      "CREATE VIEW #{table_name} AS"
    end

    def drop_query
      "DROP VIEW #{table_name};"
    end

    def from_query
      return nil if from_stack.empty?
      "FROM\n  " + from_stack.join(",\n  ")
    end

    def select_query
      return nil if select_stack.empty?
      "SELECT\n  " + select_stack.join(",\n  ")
    end

    def group_by_query
      return nil if group_by_stack.empty?
      "GROUP BY\n  " + group_by_stack.join(",\n  ")
    end

    def compact_join(*arr, sep: '')
      arr.map(&:presence).compact.map(&:to_s).join(sep)
    end
  end
end
