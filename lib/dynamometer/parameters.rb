module Dynamometer
  class Parameters < ActionController::Parameters

    def hash_filter(params, filter)
      filter = filter.with_indifferent_access
      # this is tricky - we grab the :dynamic_attributes key from params
      # and use it to check the rest of our keys
      #
      if filter.has_key?('dynamic_attributes')
        model = filter.delete('dynamic_attributes')
        self.keys.each do |key|
          # if the key is already in params it's OK
          next if params[key] || !model.permitted_dynamic_attribute?(key)
          permitted_scalar_filter(params, key)
        end
      end
      super(params, filter)
    end
  end
end
