# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'money/version'
require 'money/cross_rate'
require 'money/input_sanitizer'

Gem::Specification.new do |spec|
  spec.name          = "money"
  spec.version       = Money::VERSION
  spec.authors       = ["Sascha Burku"]
  spec.email         = ["sascha_burku@yahoo.de"]

  spec.summary       = %q{Is currency converter including arithmetics operations.}
  spec.description   = %q{The currency converter Money::LiveConverter takes two arguments, a number and a String. Instancing this class more than one times it is possible to perform operations based on Money::LiveConverter methods. }
  spec.homepage      = "http://sburku.no-ip.biz"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib","test"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
end
