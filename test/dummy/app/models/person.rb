class Person < ActiveRecord::Base
  include DynamicAttributes

  def active_model_serializer
    PersonSerializer
  end

end
