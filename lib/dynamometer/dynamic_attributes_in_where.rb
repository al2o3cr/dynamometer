module Dynamometer
  module DynamicAttributesInWhere

    def where(*args)
      return super if !args.first.is_a?(Hash) || args.first.keys.any? { |x| x.is_a?(Hash) }
      regulars, dynamics = klass.partition_wheres(args.first)
      if dynamics.empty?
        super
      else
        super(regulars).where_dynamic_attributes(dynamics)
      end
    end

    def where_dynamic_attributes(filters)
      spawn.tap do |new_rel|
        (filters || {}).each do |k, v|
          new_rel.where_values += build_where("dynamic_attributes @> hstore(?, ?)", [k, v])
        end
      end
    end
  end
end
