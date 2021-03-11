# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mongoid-filterable/version'

Gem::Specification.new do |spec|
  spec.name          = 'mongoid-filterable'
  spec.version       = Mongoid::Filterable::VERSION
  spec.authors       = ['Rafael Jurado']
  spec.email         = ['rjurado@nosolosoftware.biz']
  spec.summary       = 'Easy way to add scopes to your models.'
  spec.description   = 'Easy way to add scopes to your models.'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.2'
  spec.add_development_dependency 'rspec'
  spec.add_dependency 'i18n'
  spec.add_dependency 'mongoid', ['>= 3.0', '< 8.0']
end
