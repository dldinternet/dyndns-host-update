# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dyndns-host-update/version'

Gem::Specification.new do |spec|
  spec.name          = "dyndns-host-update"
  spec.version       = DynDNSHostUpdate::VERSION
  spec.authors       = ["Christo De Lange"]
  spec.email         = ["github@dldinternet.com"]
  spec.description   = %q{Update dyndns.org host ip address when necessary}
  spec.summary       = %q{Simple dyndns.org host ip updater driven by a YAML configuration file so that it can be used for multiple hosts}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'i18n'
  spec.add_dependency 'rubyforge'
  spec.add_development_dependency "rake"
  spec.add_development_dependency "hoe"

  spec.add_development_dependency "rspec", ">= 2.8.0"
  spec.add_development_dependency "rdoc", ">= 3.12"
  spec.add_development_dependency "cucumber", ">= 0"
  spec.add_development_dependency "bundler", ">= 1.0.0"
  spec.add_development_dependency "jeweler", ">= 1.8.4"
  #spec.add_development_dependency "rcov", ">= 0"
  spec.add_development_dependency "simplecov", ">= 0"

end
