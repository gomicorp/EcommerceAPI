module ViewTableBuilder
  def create_view(table_name)
    @builder = ViewBuilder.new(table_name)
    yield(@builder)
    execute @builder.build_create_query
  end

  def update_view(table_name)
    @builder = ViewBuilder.new(table_name)
    yield(@builder)
    execute @builder.build_update_query
  end

  def drop_view(table_name)
    @builder = ViewBuilder.new(table_name)
    execute @builder.build_drop_query
  end


  class ViewBuilder
    attr_reader :table_name
    attr_reader :from_stack, :select_stack, :inner_join_stack, :where_stack, :group_by_stack

    def initialize(table_name)
      @table_name = table_name

      @from_stack = []
      @select_stack = []
      @inner_join_stack = []
      @where_stack = []
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

    def inner_join(join_table, conditions)
      clause = "#{join_table}\nON "

      conditions.map.with_index do |v, i|
        clause << "\nAND " if i > 0
        clause << compile_condition_clause(v)
      end

      inner_join_stack << clause
    end

    def where(condition)
      where_stack << compile_condition_clause(condition)
    end

    def group_by(clause)
      group_by_stack << clause
    end

    def build_create_query
      [
        create_query,
        select_query,
        from_query,
        inner_join_query,
        where_query,
        group_by_query
      ].join("\n")
    end

    def build_update_query
      [
        update_query,
        select_query,
        from_query,
        inner_join_query,
        where_query,
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

    def update_query
      "ALTER VIEW #{table_name} AS"
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

    def inner_join_query
      return nil if inner_join_stack.empty?
      inner_join_stack.map { |clause| "INNER JOIN\n #{clause}" }.join("\n")
    end

    def where_query
      return nil if where_stack.empty?
      "WHERE\n " + where_stack.join("\nAND ")
    end

    def group_by_query
      return nil if group_by_stack.empty?
      "GROUP BY\n  " + group_by_stack.join(",\n  ")
    end

    def compact_join(*arr, sep: '')
      arr.map(&:presence).compact.map(&:to_s).join(sep)
    end


    protected

    def compile_condition_clause(clause)
      s = ""
      clause.map do |k, v|
        s << "#{k}.#{v} "
      end
      if clause.size == 1
        s << "IS NULL"
      else
        s.split(" ").join(" = ")
      end
    end
  end
end
