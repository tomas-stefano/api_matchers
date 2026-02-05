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
    autoload :HaveHeader, 'api_matchers/headers/have_header'
    autoload :HaveCorsHeaders, 'api_matchers/headers/have_cors_headers'
    autoload :HaveCacheControl, 'api_matchers/headers/have_cache_control'
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

  # HTTP Status Matchers
  #
  module HTTPStatus
    autoload :Base, 'api_matchers/http_status/base'
    autoload :HaveHttpStatus, 'api_matchers/http_status/have_http_status'
    autoload :BeSuccessful, 'api_matchers/http_status/be_successful'
    autoload :BeRedirect, 'api_matchers/http_status/be_redirect'
    autoload :BeClientError, 'api_matchers/http_status/be_client_error'
    autoload :BeServerError, 'api_matchers/http_status/be_server_error'
    autoload :BeNotFound, 'api_matchers/http_status/be_not_found'
    autoload :BeUnauthorized, 'api_matchers/http_status/be_unauthorized'
    autoload :BeForbidden, 'api_matchers/http_status/be_forbidden'
    autoload :BeUnprocessable, 'api_matchers/http_status/be_unprocessable'
    autoload :BeNoContent, 'api_matchers/http_status/be_no_content'
  end

  # JSON Structure Matchers
  #
  module JsonStructure
    autoload :Base, 'api_matchers/json_structure/base'
    autoload :HaveJsonKeys, 'api_matchers/json_structure/have_json_keys'
    autoload :HaveJsonType, 'api_matchers/json_structure/have_json_type'
  end

  # Collection Matchers
  #
  module Collection
    autoload :Base, 'api_matchers/collection/base'
    autoload :HaveJsonSize, 'api_matchers/collection/have_json_size'
    autoload :BeSortedBy, 'api_matchers/collection/be_sorted_by'
  end

  # Pagination Matchers
  #
  module Pagination
    autoload :Base, 'api_matchers/pagination/base'
    autoload :BePaginated, 'api_matchers/pagination/be_paginated'
    autoload :HavePaginationLinks, 'api_matchers/pagination/have_pagination_links'
    autoload :HaveTotalCount, 'api_matchers/pagination/have_total_count'
  end

  # Error Response Matchers
  #
  module ErrorResponse
    autoload :Base, 'api_matchers/error_response/base'
    autoload :HaveError, 'api_matchers/error_response/have_error'
    autoload :HaveErrorOn, 'api_matchers/error_response/have_error_on'
  end

  # JSON:API Matchers
  #
  module JsonApi
    autoload :Base, 'api_matchers/json_api/base'
    autoload :BeJsonApiCompliant, 'api_matchers/json_api/be_json_api_compliant'
    autoload :HaveJsonApiData, 'api_matchers/json_api/have_json_api_data'
    autoload :HaveJsonApiAttributes, 'api_matchers/json_api/have_json_api_attributes'
    autoload :HaveJsonApiRelationships, 'api_matchers/json_api/have_json_api_relationships'
  end

  # HATEOAS Matchers
  #
  module Hateoas
    autoload :Base, 'api_matchers/hateoas/base'
    autoload :HaveLink, 'api_matchers/hateoas/have_link'
  end

  # Core
  #
  module Core
    autoload :FindInJSON, 'api_matchers/core/find_in_json'
    autoload :ValueNormalizer, 'api_matchers/core/value_normalizer'
    autoload :Parser, 'api_matchers/core/parser'
    autoload :Setup, 'api_matchers/core/setup'
    autoload :Exceptions, 'api_matchers/core/exceptions'
    autoload :HTTPStatusCodes, 'api_matchers/core/http_status_codes'
    autoload :JsonPathFinder, 'api_matchers/core/json_path_finder'
  end
  include ::APIMatchers::Core::Exceptions

  def self.setup
    yield(::APIMatchers::Core::Setup)
  end
end
