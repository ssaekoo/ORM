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
