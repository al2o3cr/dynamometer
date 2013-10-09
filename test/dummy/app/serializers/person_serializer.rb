class PersonSerializer < ActiveModel::Serializer
  include DynamicAttributesSerializer

  attributes :name
end
