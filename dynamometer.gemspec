# coding: utf-8
$:.push File.expand_path("../lib", __FILE__)

require "dynamometer/version"

Gem::Specification.new do |spec|
  spec.name          = "dynamometer"
  spec.version       = Dynamometer::VERSION
  spec.authors       = ["John Colvin"]
  spec.email         = ["john.colvin@neo.com"]
  spec.description   = "Adds support for searchable, sortable, dynamic ActiveRecord attributes"
  spec.summary       = "Makes dynamic attributes in an hstore column appear as top level attribute."
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", "< 4.3.0"
  spec.add_dependency "pg"
  # tricky: AMS 0.9.0 and ActionController 4.2 do not play nice togther
  # see https://github.com/rails-api/active_model_serializers/issues/643
  # for details
  spec.add_development_dependency "active_model_serializers", "< 0.9.0"
  spec.add_development_dependency "rails", "< 4.3.0"
end
