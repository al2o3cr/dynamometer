class Person < ActiveRecord::Base
  include DynamicAttributes

  belongs_to :father, class_name: 'Person'

  def active_model_serializer
    PersonSerializer
  end

end
