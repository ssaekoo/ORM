require_relative 'searchable'
require 'active_support/inflector'
require_relative 'options'

module Associatable
  def belongs_to(name, options = {})
    self.assoc_options[name] = BelongsToOptions.new(name, options)
    define_method(name) do
      options = self.class.assoc_options[name]
      foreign_key = self.send(options.foreign_key)
      options
        .model_class
        .where(options.primary_key => foreign_key)
        .first
    end
  end

  def has_many(name, options = {})
    self.assoc_options[name] = HasManyOptions.new(name, self.name, options)
    define_method(name) do
      options = self.class.assoc_options[name]
      foreign_key = self.send(options.primary_key)
      options
        .model_class
        .where(options.foreign_key => foreign_key)
    end
  end

  def assoc_options
    @assoc_options ||= {}
    @assoc_options
  end

  def has_one_through(name, through_name, source_name)
    define_method(name) do
      through = self.class.assoc_options[through_name]
      through_table = through.table_name
      through_pk = through.primary_key
      through_fk = through.foreign_key

      source = through.model_class.assoc_options[source_name]
      source_table = source.table_name
      source_pk = source.primary_key
      source_fk = source.foreign_key

      key_val = self.send(through_fk)
      results = DBConnection.execute(<<-SQL, key_val)
        SELECT
          #{source_table}.*
        FROM
          #{source_table}
        JOIN
          #{through_table}
        ON
          #{through_table}.#{source_fk} = #{source_table}.#{source_pk}
        WHERE
          #{through_table}.#{through_pk} = ?
      SQL

      through.model_class.assoc_options[source_name].model_class.parse_all(results).first
    end
  end
end

class SQLObject
  extend Associatable
end
