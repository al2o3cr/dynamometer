module DynamicAttributes

  extend ActiveSupport::Concern

  def [](name)
    attribute_name = name.to_s
    if has_attribute?(attribute_name)
      super
    elsif has_dynamic_attribute?(attribute_name)
      read_dynamic_attribute(attribute_name)
    else
      super
    end
  end

  def []=(key, value)
    begin
      super
    rescue ActiveModel::MissingAttributeError
      write_dynamic_attribute(key, value)
    end
  end

  def method_missing(name, *args)
    method_name = name.to_s
    if method_name =~ /^[\w]+\=$/
      write_dynamic_attribute(method_name.chop, args[0])
    elsif has_dynamic_attribute?(method_name)
      read_dynamic_attribute(method_name)
    else
      super
    end
  end

  def attributes
    attrs = super
    props = attrs.delete('dynamic_attributes') || {}
    attrs.merge(props)
  end

  def dynamic_attributes
    self[:dynamic_attributes] || {}
  end

  private

  def has_dynamic_attribute?(name)
    dynamic_attributes.has_key?(name.to_s)
  end

  def read_dynamic_attribute(name)
    dynamic_attributes[name]
  end

  def write_dynamic_attribute(name, value)
    self[:dynamic_attributes] = dynamic_attributes.merge(name => value)
    value
  end

end