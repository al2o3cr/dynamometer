require 'dynamometer/dynamic_attributes_in_where'

module Dynamometer
  class Railtie < Rails::Engine
    railtie_name :dynamometer

    initializer "dynamometer.active_record" do
      ActiveSupport.on_load :active_record do
        ActiveRecord::Querying.module_eval do
          delegate :where_dynamic_attributes, to: :all
        end

        ActiveRecord::Base.class_eval do
          def self.partition_wheres(args); [args,{}]; end
        end

        ActiveRecord::Relation.send(:include, DynamicAttributesInWhere)
      end
    end
  end
end

