require 'active_support/inflector'

require_relative 'db_connection'
require_relative 'associatable'
require_relative 'searchable'

class SQLObject
  extend Searchable
  extend Associatable

  def self.columns
    return @columns if @columns

    columns = DBConnection.execute2(<<-SQL).first
      SELECT
        *
      FROM
        #{self.table_name}
      LIMIT
        0
    SQL
    columns.map!(&:to_sym)
    @columns = columns
  end

  def self.finalize!
    self.columns.each do |name|
      define_method(name) do
        self.attributes[name]
      end

      define_method("#{name}=") do |value|
        self.attributes[name] = value
      end
    end
  end

  def self.table_name
    @table_name || self.name.underscore.pluralize
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.all
    results = DBConnection.execute(<<-SQL)
      SELECT
        #{table_name}.*
      FROM
        #{table_name}
    SQL

    parse_all(results)
  end

  def self.parse_all(results)
    results.map do |result|
      self.new(result)
    end
  end

  def self.find(id)
    results = DBConnection.execute(<<-SQL, id)
      SELECT
        #{table_name}.*
      FROM
        #{table_name}
      WHERE
        #{table_name}.id = ?
    SQL

    parse_all(results).first
  end

  def initialize(params = {})
    params.each do |attr_name, value|
      # keys to symbols
      attr_name = attr_name.to_sym

      unless self.class.columns.include?(attr_name)
        raise "unknown attribute '#{attr_name}'"
      end
      send("#{attr_name}=", attr_value)
    end

  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.columns.map do |attr|
      self.send(attr)
    end
  end

  def insert
    # drop the id col
    columns = self.class.columns.drop(1)

    # variables entered into query must be strings
    col_names = columns.map(&:to_s).join(", ")
    question_marks = (["?"] * columns.count).join(", ")

    DBConnection.execute(<<-SQL, *attribute_values.drop(1))
      INSERT INTO
        #{self.class.table_name} (#{col_names})
      VALUES
        (#{question_marks})
    SQL

    # ensure each row has unique id
    self.id = DBConnection.last_insert_row_id
  end

  def update
    set_line = self.class.columns
      .map { |attr| "#{attr} = ?" }.join(", ")

    DBConnection.execute(<<-SQL, *attribute_values, id)
      UPDATE
        #{self.class.table_name}
      SET
        #{set_line}
      WHERE
        #{self.class.table_name}.id = ?
    SQL
  end

  def save
    id.nil? ? insert : update
  end

  def destroy
    DBConnection.execute(<<-SQL, self.id)
      DELETE FROM
        #{self.class.table_name}
      WHERE
        id = ?
    SQL
  end

end
