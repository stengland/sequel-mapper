# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_mapper/version'

Gem::Specification.new do |spec|
  spec.name          = "simple_mapper"
  spec.version       = SimpleMapper::VERSION
  spec.authors       = ["Steve England"]
  spec.email         = ["stephen.england@gmail.com"]
  spec.summary       = 'Super simple ORM build on Sequel'
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency('sequel')
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "rake"
end
