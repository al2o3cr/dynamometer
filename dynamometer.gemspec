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

  spec.add_dependency "rails", "~> 4.0.0"
  spec.add_dependency "pg"
  spec.add_development_dependency "active_model_serializers"
end
