# -*- encoding: utf-8 -*-
require File.expand_path('../lib/api_matchers/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Tomas D'Stefano"]
  gem.email         = ["tomas_stefano@successoft.com"]
  gem.description   = %q{Collection of RSpec matchers for create your API.}
  gem.summary       = %q{Collection of RSpec matchers for create your API.}
  gem.homepage      = "https://github.com/tomas-stefano/api_matchers"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "api_matchers"
  gem.require_paths = ["lib"]
  gem.version       = APIMatchers::VERSION

  gem.add_dependency 'rspec', '~> 3.1'
  gem.add_dependency 'activesupport', '>= 3.2.5'
  gem.add_dependency 'nokogiri', '>= 1.5.2'
end
