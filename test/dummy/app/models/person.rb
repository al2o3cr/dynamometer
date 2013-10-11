class Person < ActiveRecord::Base
  include DynamicAttributes

  belongs_to :father, class_name: 'Person'

  dynamic_attributes :hometown

  validates_length_of :hometown, minimum: 3, allow_nil: true

  def active_model_serializer
    PersonSerializer
  end

end
