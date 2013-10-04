module DynamicAttributes

  extend ActiveSupport::Concern

  def [](attr_name)
    if @attributes.keys.include?(attr_name.to_s)
      super
    elsif has_dynamic_attribute?(attr_name)
      read_dynamic_attribute(attr_name)
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

  def method_missing(method, *args)
    if has_dynamic_attribute?(method)
      read_dynamic_attribute(method)
    elsif method =~ /^[\w]+\=$/
      write_dynamic_attribute(method.to_s.chop, args[0])
    else
      super
    end
  end

  def attributes
    attrs = super
    dynamic_attrs = attrs.delete('dynamic_attributes') || {}
    dynamic_attrs.merge(attrs)
  end

  def dynamic_attributes
    self['dynamic_attributes'] || {}
  end

  def has_attribute?(attr_name)
    super || has_dynamic_attribute?(attr_name)
  end

  private

  def has_dynamic_attribute?(attr_name)
    dynamic_attributes.has_key?(attr_name.to_s)
  end

  def read_dynamic_attribute(attr_name)
    dynamic_attributes[attr_name.to_s]
  end

  def write_dynamic_attribute(attr_name, value)
    @attributes.merge('dynamic_attributes' => dynamic_attributes.merge(attr_name.to_s => value))
    value
  end

end