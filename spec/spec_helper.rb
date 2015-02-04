require 'active_support'
require 'api_matchers'
require 'ostruct'

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.include APIMatchers::RSpecMatchers

  def fail_with(message)
    raise_error(RSpec::Expectations::ExpectationNotMetError, message)
  end
end
