lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'doppelserver/version'

Gem::Specification.new do |spec|
  spec.name          = 'doppelserver'
  spec.version       = Doppelserver::VERSION
  spec.authors       = ['Drew Cooper']
  spec.email         = ['drewcoo@gmail.com']
  spec.summary       = "DO NOT USE YET!!! EXPERIMENTAL.\n\n" \
                       'A REST server and a client that knows how to talk ' \
                       'to it, so be used for test fakes.'
  spec.description   = "DO NOT USE YET!!! EXPERIMENTAL.\n\n" \
                       'Unlike mocks and stubs, fake services are running ' \
                       'processes that pretend to function as real ones ' \
                       'would. This enables testing the software under test ' \
                       'with more complete control of the surfaces it talks ' \
                       'to (other services, faked). Beyond that, it makes ' \
                       'application- and (http)protocol-level fault ' \
                       'injection easy.'
  spec.homepage      = 'https://github.com/drewcoo/doppelserver'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the
  # 'allowed_push_host' to allow pushing to a single host or delete this
  # section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org/gems/doppleserver'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
          'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'activesupport', '~> 5.0'
  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'coveralls', '~> 0.8'
  spec.add_development_dependency 'drewcoo-cops', '~> 0.1'
  spec.add_development_dependency 'faraday', '~> 0.10' # TODO: development only?
  spec.add_development_dependency 'gem-release', '~> 1.0'
  # spec.add_development_dependency 'rack-test', '~> 0.6'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec_junit_formatter', '~> 0.3'
  spec.add_development_dependency 'rubocop', '~> 0.55'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.25'
  spec.add_development_dependency 'simplecov', '~> 0.12'
  spec.add_development_dependency 'sinatra', '~> 1.4'
  spec.add_development_dependency 'sinatra-contrib', '~> 1.4'
end
