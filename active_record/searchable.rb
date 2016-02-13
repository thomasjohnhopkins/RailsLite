module Searchable
  def where(params)
    where_details = params.keys.map { |key| "#{key} = ?" }.join(" AND ")

    results = DBConnection.execute(<<-SQL, *params.values)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        #{where_details}
    SQL

    parse_all(results)
  end
end
