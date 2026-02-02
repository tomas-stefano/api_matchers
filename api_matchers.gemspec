# frozen_string_literal: true

require File.expand_path('../lib/api_matchers/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Tomas D'Stefano"]
  gem.email         = ["tomas_stefano@successoft.com"]
  gem.description   = %q{Collection of RSpec matchers for your API.}
  gem.summary       = %q{Collection of RSpec matchers for your API.}
  gem.homepage      = "https://github.com/tomas-stefano/api_matchers"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "api_matchers"
  gem.require_paths = ["lib"]
  gem.version       = APIMatchers::VERSION

  gem.required_ruby_version = '>= 3.1'

  gem.add_dependency 'rspec', '>= 3.12', '< 4.0'
  gem.add_dependency 'activesupport', '>= 7.0', '< 9.0'
  gem.add_dependency 'nokogiri', '>= 1.15'

  gem.add_development_dependency 'rake', '~> 13.0'
  gem.add_development_dependency 'json_schemer', '~> 2.0'
end
