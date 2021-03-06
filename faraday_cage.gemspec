# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'faraday_cage/version'

Gem::Specification.new do |gem|
  gem.name          = 'faraday_cage'
  gem.version       = FaradayCage::VERSION
  gem.authors       = ['Gabriel Evans']
  gem.email         = ['gabe@tabeso.com']
  gem.description   = %q{Faraday Cage allows you to use Faraday for making requests to your REST APIs in integration testing, minus the boilerplate code and crufty parsing and encoding of requests and responses.}
  gem.summary       = %q{Use Faraday to integration test your REST applications.}
  gem.homepage      = 'https://github.com/tabeso/faraday_cage'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'rack', '>= 1.4.0'
  gem.add_dependency 'rack-test', '>= 0.5.4'
  gem.add_dependency 'faraday_middleware', '>= 0.8', '< 1.0'
  gem.add_dependency 'activesupport'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'yard'
  gem.add_development_dependency 'redcarpet'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'simplecov'

  gem.add_development_dependency 'guard'
  gem.add_development_dependency 'guard-bundler'
  gem.add_development_dependency 'guard-rspec'
  gem.add_development_dependency 'guard-yard'
  gem.add_development_dependency 'rb-fsevent'
  gem.add_development_dependency 'rb-inotify'
  gem.add_development_dependency 'growl'
end
