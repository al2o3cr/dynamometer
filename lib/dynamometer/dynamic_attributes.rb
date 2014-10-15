module Dynamometer
  module DynamicAttributes

    extend ActiveSupport::Concern

    module ClassMethods
      # we only define this for classes with dynamic attributes
      # so that unmodified classes work exactly as before
      def partition_wheres(wheres)
        wheres.partition { |k, v| column_names.include?(k.to_s) || reflect_on_association(k.to_sym) }.map { |x| Hash[x] }
      end

      def dynamic_attributes(*args)
        @_dynamic_attributes ||= []
        @_dynamic_attributes |= args.map(&:to_s)

        args.each do |attr|
          class_eval <<-ENDOFCODE
            def #{attr}
              read_dynamic_attribute(#{attr.inspect})
            end

            def #{attr}=(v)
              write_dynamic_attribute(#{attr.inspect}, v)
            end
          ENDOFCODE
        end
      end

      def permitted_dynamic_attribute?(attr)
        # make sure the regular attributes have been defined
        define_attribute_methods
        @_dynamic_attributes.include?(attr.to_s) || instance_methods.none? { |m| m.to_s == attr.to_s }
      end
    end

    def [](attr_name)
      if @attributes.key?(attr_name.to_s)
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

    def method_missing(method, *args, &block)
      if self.class.define_attribute_methods && respond_to_without_attributes?(method)
        # this reproduces some behavior from AR's method_missing, as a safeguard
        # against dynamic attributes shadowing real ones
        send(method, *args, &block)
      elsif has_dynamic_attribute?(method)
        read_dynamic_attribute(method)
      elsif method =~ /^([\w]+)\=$/
        write_dynamic_attribute($1, args[0])
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
      self['dynamic_attributes'].blank? ? {} : self['dynamic_attributes']
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
      self['dynamic_attributes'] = dynamic_attributes.merge(attr_name.to_s => value)
      value
    end

  end
end
