# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mongoid-filterable/version'

Gem::Specification.new do |spec|
  spec.name          = "mongoid-filterable"
  spec.version       = Mongoid::Filterable::VERSION
  spec.authors       = ["Rafael Jurado"]
  spec.email         = ["rjurado@nosolosoftware.biz"]
  spec.summary       = %q{Easy way to add scopes to your models.}
  spec.description   = %q{Easy way to add scopes to your models.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency 'rspec'
  spec.add_dependency 'mongoid'
  spec.add_dependency "i18n"
end
