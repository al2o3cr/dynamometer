module Dynamometer
  class Railtie < Rails::Engine
    railtie_name :dynamometer

    initializer "dynamometer.active_record" do
      ActiveSupport.on_load :active_record do
        ActiveRecord::Querying.module_eval do
          delegate :where_dynamic_attributes, to: :all
        end

        ActiveRecord::QueryMethods.module_eval do
          def where_dynamic_attributes(filters)
            spawn.tap do |new_rel|
              (filters || {}).each do |k, v|
                new_rel.where_values += build_where("dynamic_attributes @> hstore(?, ?)", [k, v])
              end
            end
          end
        end
      end
    end
  end
end

