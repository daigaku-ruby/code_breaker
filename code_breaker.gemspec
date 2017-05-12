# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'code_breaker/version'

Gem::Specification.new do |spec|
  spec.name          = 'code_breaker'
  spec.version       = CodeBreaker::VERSION
  spec.authors       = ['Paul Götze']
  spec.email         = ['paul.christoph.goetze@gmail.com']

  spec.summary       = 'Breaking a Ruby code snippet into a sequence of classes and their connecting methods.'
  spec.description   = 'Breaking a Ruby code snippet into a sequence of classes and their connecting methods.'
  spec.homepage      = 'https://github.com/daigaku-ruby/code_breaker'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'parser', '~> 2.4'

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake',    '~> 12.0'
  spec.add_development_dependency 'rspec',   '~> 3.6'
end
