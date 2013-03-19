require "api_matchers/version"
require "active_support/core_ext/object"
require "active_support/core_ext/class"

module APIMatchers
  autoload :RSpecMatchers, 'api_matchers/core/rspec_matchers'

  # HTTP Status Code Matchers
  #
  module HTTPStatusCode
    autoload :Base, 'api_matchers/http_status_code/base'
    autoload :BeBadRequest, 'api_matchers/http_status_code/be_bad_request'
    autoload :BeInternalServerError, 'api_matchers/http_status_code/be_internal_server_error'
    autoload :BeUnauthorized, 'api_matchers/http_status_code/be_unauthorized'
    autoload :BeOk, 'api_matchers/http_status_code/be_ok'
    autoload :CreateResource, 'api_matchers/http_status_code/create_resource'
  end

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
    autoload :HaveXmlNode,  'api_matchers/response_body/have_xml_node'
    autoload :HaveNode, 'api_matchers/response_body/have_node'
  end

  # Core
  #
  module Core
    autoload :FindInJSON, 'api_matchers/core/find_in_json'
    autoload :Setup, 'api_matchers/core/setup'
    autoload :Exceptions, 'api_matchers/core/exceptions'
  end
  include ::APIMatchers::Core::Exceptions

  def self.setup
    yield(::APIMatchers::Core::Setup)
  end
end
