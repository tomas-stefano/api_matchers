# frozen_string_literal: true

require "api_matchers/version"
require "active_support/core_ext/object"
require "active_support/core_ext/class"

module APIMatchers
  autoload :RSpecMatchers, 'api_matchers/core/rspec_matchers'

  # Content Type Matchers
  #
  module Headers
    autoload :Base, 'api_matchers/headers/base'
    autoload :BeXML, 'api_matchers/headers/be_xml'
    autoload :BeJSON, 'api_matchers/headers/be_json'
  end

  # Response Body Matchers
  #
  module ResponseBody
    autoload :Base, 'api_matchers/response_body/base'
    autoload :HaveJsonNode, 'api_matchers/response_body/have_json_node'
    autoload :HaveJson, 'api_matchers/response_body/have_json'
    autoload :HaveXmlNode,  'api_matchers/response_body/have_xml_node'
    autoload :HaveNode, 'api_matchers/response_body/have_node'
    autoload :MatchJsonSchema, 'api_matchers/response_body/match_json_schema'
  end

  # Core
  #
  module Core
    autoload :FindInJSON, 'api_matchers/core/find_in_json'
    autoload :ValueNormalizer, 'api_matchers/core/value_normalizer'
    autoload :Parser, 'api_matchers/core/parser'
    autoload :Setup, 'api_matchers/core/setup'
    autoload :Exceptions, 'api_matchers/core/exceptions'
  end
  include ::APIMatchers::Core::Exceptions

  def self.setup
    yield(::APIMatchers::Core::Setup)
  end
end
