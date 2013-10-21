require 'dynamometer/parameters'

module PermitDynamic
  extend ActiveSupport::Concern

  # extend ActionController::Parameters to allow dynamic attributes

  def params
    @_params ||= Dynamometer::Parameters.new(request.parameters)
  end

  # Assigns the given +value+ to the +params+ hash. If +value+
  # is a Hash, this will create an ActionController::Parameters
  # object that has been instantiated with the given +value+ hash.
  def params=(value)
    @_params = value.is_a?(Hash) ? Dynamometer::Parameters.new(value) : value
  end

end
