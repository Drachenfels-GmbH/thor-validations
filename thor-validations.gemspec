# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'thor-validations/version'

Gem::Specification.new do |gem|
  gem.name          = "thor-validations"
  gem.version       = Thor::Validations::VERSION
  gem.authors       = ["Ruben Jenster"]
  gem.email         = ["r.jenster@drachenfels.de"]
  gem.description   = %q{Validations for thor options}
  gem.summary       = %q{Validations for thor options}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_development_dependency "rake"
  gem.add_dependency "thor"
end
