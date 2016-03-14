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
