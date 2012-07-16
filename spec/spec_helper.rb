require 'api_matchers'
require 'ostruct'

RSpec.configure do |config|
  config.include APIMatchers::RSpecMatchers

  def fail_with(message)
    raise_error(RSpec::Expectations::ExpectationNotMetError, message)
  end
end
