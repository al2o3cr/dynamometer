# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dynamic/attributes/version'

Gem::Specification.new do |spec|
  spec.name          = "dynamic-attributes"
  spec.version       = Dynamic::Attributes::VERSION
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

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
