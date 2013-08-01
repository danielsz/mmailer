# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mmailer/version'

Gem::Specification.new do |spec|
  spec.name          = "mmailer"
  spec.version       = Mmailer::VERSION
  spec.authors       = ["Daniel Szmulewicz"]
  spec.email         = ["danielsz@freeshell.org"]
  spec.description   = %q{Bulk mailer with remote control (drb server)}
  spec.summary       = %q{Bulk mailing the Ruby way}
  spec.homepage      = "https://github.com/danielsz/mmailer"
  spec.license       = "LGPL.v3"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  spec.add_runtime_dependency 'thor'
  spec.add_runtime_dependency 'mail'
  spec.add_runtime_dependency 'micromachine'
  spec.add_runtime_dependency 'kramdown'
end
