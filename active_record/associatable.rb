require 'active_support/inflector'

require_relative 'searchable'

class AssocOptions
  attr_accessor :foreign_key, :class_name, :primary_key


  def model_class
    class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    @foreign_key = options[:foreign_key] || "#{name}_id".to_sym
    @primary_key = options[:primary_key] || :id
    @class_name = options[:class_name] || name.to_s.singularize.camelcase
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    @foreign_key = options[:foreign_key] || "#{self_class_name}_id".downcase.to_sym
    @primary_key = options[:primary_key] || :id
    @class_name = options[:class_name] || name.to_s.singularize.camelcase
  end
end

module Associatable

  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)
    assoc_options[name] = options

    define_method(name) do
      owner_class = options.model_class

      value = send(options.foreign_key)
      owner_class.where(options.primary_key => value).first
    end
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self, options)
    assoc_options[name] = options

    define_method(name) do
      belong_class = options.model_class

      value = send(options.primary_key)
      belong_class.where(options.foreign_key => value)
    end
  end

  def assoc_options
    @assoc_options ||= {}
  end

  def has_one_through(name, through_name, source_name)
    through_options = self.assoc_options[through_name]

    define_method(name) do
      source_options = through_options.model_class.assoc_options[source_name]

      through_table = through_options.table_name
      through_p_key = through_options.primary_key
      through_f_key = through_options.foreign_key

      source_table = source_options.table_name
      source_p_key = source_options.primary_key
      source_f_key = source_options.foreign_key

      value = send(through_fk)
      results = DBConnection.execute(<<-SQL, value)
        SELECT
          #{source_table}.*
        FROM
          #{through_table}
        JOIN
          #{source_table}
        ON
          #{through_table}.#{source_f_key} = #{source_table}.#{source_p_key}
        WHERE
          #{through_table}.#{through_p_key} = ?
      SQL

      source_options.model_class.parse_all(results).first
    end
  end

  def has_many_through(name, through_name, source_name)
    through_options = self.assoc_options[through_name]
    define_method(name) do
      source_options = through_options.model_class.assoc_options[source_name]
      value = send(through_options.primary_key)
      results = DBConnection.execute(<<-SQL, value)
        SELECT
          #{source_options.table_name}.*
        FROM
          #{through_options.table_name}
        JOIN
          #{source_options.table_name}
          ON  #{through_options.table_name}.#{source_options.foreign_key} =
              #{source_options.table_name}.#{source_options.primary_key}
        WHERE
          #{through_options.table_name}.#{through_options.foreign_key} = ?
      SQL
      source_options.model_class.parse_all(results)
    end
  end

end
