require 'dynamometer/dynamic_attributes'
require 'dynamometer/dynamic_attributes_in_where'
require 'dynamometer/dynamic_attributes_serializer'
require 'dynamometer/version'
require 'dynamometer/railtie' if defined?(Rails)

module Dynamometer
  # attach the necessary support to ActiveRecord
  # called automatically by the railtie, but must be called
  # after ActiveRecord::Base is loaded outside of Rails
  #
  def attach
    ActiveRecord::Querying.module_eval do
      delegate :where_dynamic_attributes, to: :all
    end

    ActiveRecord::Base.class_eval do
      def self.partition_wheres(args); [args,{}]; end
    end

    ActiveRecord::Relation.send(:include, DynamicAttributesInWhere)
  end
  module_function :attach
end
