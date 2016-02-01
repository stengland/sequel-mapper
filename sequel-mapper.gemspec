# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sequel/mapper/version'

Gem::Specification.new do |spec|
  spec.name          = "sequel-mapper"
  spec.version       = Sequel::Mapper::VERSION
  spec.authors       = ["Steve England"]
  spec.email         = ["stephen.england@gmail.com"]
  spec.summary       = 'Super simple object mapper/repo built on Sequel'

  spec.description   = %q{Super simpler object mapper built on Sequel (http://sequel.jeremyevans.net/) and using the repository pattern http://martinfowler.com/eaaCatalog/repository.html}
  spec.homepage      = "https://github.com/stengland/sequel-mapper"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency('sequel')
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "sqlite3"
end
