require_relative 'searchable'
require 'active_support/inflector'

class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    @class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})

    defaults = {
      primary_key: :id,
      class_name: name.to_s.camelcase,
      foreign_key: "#{name}_id".to_sym
    }

    defaults.each do |key, value|
      self.send("#{key}=", options[key] || defaults[key])
    end
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    defaults = {
      primary_key: :id,
      class_name: name.to_s.singularize.capitalize,
      foreign_key: self_class_name.underscore.concat("_id").to_sym
    }

    defaults.each do |key, value|
      self.send("#{key}=", options[key] || defaults[key])
    end
  end
end
