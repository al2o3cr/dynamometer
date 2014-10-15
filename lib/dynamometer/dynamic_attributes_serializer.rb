module Dynamometer
  module DynamicAttributesSerializer
    def attributes
      super.merge(object.dynamic_attributes)
    end
  end
end
