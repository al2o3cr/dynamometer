module DynamicAttributes

  extend ActiveSupport::Concern

  def [](name)
    attribute_name = name.to_s
    if attribute_name == 'dynamic_attributes' || !has_dynamic_attribute?(attribute_name)
      super
    else
      dynamic_attributes[attribute_name]
    end
  end

  def []=(key, value)
    begin
      super
    rescue ActiveModel::MissingAttributeError
      send "#{key}=", value
    end
  end

  def method_missing(name, *args)
    method_name = name.to_s
    if method_name =~ /^[\w]+\=$/
      self[:dynamic_attributes] = dynamic_attributes.merge(method_name.chop => args[0])
      args[0]
    elsif has_dynamic_attribute?(method_name)
      self[method_name]
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

end