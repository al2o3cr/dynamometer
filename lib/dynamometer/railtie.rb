require 'dynamometer/dynamic_attributes_in_where'

module Dynamometer
  class Railtie < Rails::Engine
    railtie_name :dynamometer

    initializer "dynamometer.active_record" do
      ActiveSupport.on_load :active_record do
        Dynamometer.attach
      end
    end
  end
end

