module AutoIncrement
  def auto_increment_value
    connection.execute(<<-SQL.squish).first[0]
      SELECT `AUTO_INCREMENT`
        FROM `INFORMATION_SCHEMA`.`TABLES`
       WHERE `TABLE_SCHEMA` = '#{connection.current_database}'
         AND `TABLE_NAME` = '#{table_name}'
    SQL
  end
end
