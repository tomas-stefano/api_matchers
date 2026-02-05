# frozen_string_literal: true

module APIMatchers
  module RSpecMatchers
    # Content Type Matchers
    def be_xml
      ::APIMatchers::Headers::BeXML.new
    end
    alias :be_in_xml :be_xml

    def be_json
      ::APIMatchers::Headers::BeJSON.new
    end
    alias :be_in_json :be_json
    alias :be_a_json  :be_json

    # Response Body Matchers
    def have_json_node(expected_node)
      ::APIMatchers::ResponseBody::HaveJsonNode.new(expected_node: expected_node)
    end

    def have_xml_node(expected_node)
      ::APIMatchers::ResponseBody::HaveXmlNode.new(expected_node: expected_node)
    end

    def have_json(expected_json)
      ::APIMatchers::ResponseBody::HaveJson.new(expected_json)
    end

    def have_node(expected_node)
      if ::APIMatchers::Core::Setup.have_node_matcher.equal?(:json)
        have_json_node(expected_node)
      else
        have_xml_node(expected_node)
      end
    end

    def match_json_schema(schema)
      ::APIMatchers::ResponseBody::MatchJsonSchema.new(schema: schema)
    end

    # HTTP Status Matchers
    def have_http_status(expected)
      ::APIMatchers::HTTPStatus::HaveHttpStatus.new(expected)
    end

    def be_successful
      ::APIMatchers::HTTPStatus::BeSuccessful.new
    end
    alias :be_success :be_successful

    def be_redirect
      ::APIMatchers::HTTPStatus::BeRedirect.new
    end
    alias :be_redirection :be_redirect

    def be_client_error
      ::APIMatchers::HTTPStatus::BeClientError.new
    end

    def be_server_error
      ::APIMatchers::HTTPStatus::BeServerError.new
    end

    def be_not_found
      ::APIMatchers::HTTPStatus::BeNotFound.new
    end

    def be_unauthorized
      ::APIMatchers::HTTPStatus::BeUnauthorized.new
    end

    def be_forbidden
      ::APIMatchers::HTTPStatus::BeForbidden.new
    end

    def be_unprocessable
      ::APIMatchers::HTTPStatus::BeUnprocessable.new
    end
    alias :be_unprocessable_entity :be_unprocessable

    def be_no_content
      ::APIMatchers::HTTPStatus::BeNoContent.new
    end

    # JSON Structure Matchers
    def have_json_keys(*keys)
      ::APIMatchers::JsonStructure::HaveJsonKeys.new(*keys)
    end

    def have_json_type(expected_type)
      ::APIMatchers::JsonStructure::HaveJsonType.new(expected_type)
    end

    # Collection Matchers
    def have_json_size(expected_size)
      ::APIMatchers::Collection::HaveJsonSize.new(expected_size)
    end

    def be_sorted_by(field)
      ::APIMatchers::Collection::BeSortedBy.new(field)
    end

    # Header Matchers
    def have_header(header_name)
      ::APIMatchers::Headers::HaveHeader.new(header_name)
    end

    def have_cors_headers
      ::APIMatchers::Headers::HaveCorsHeaders.new
    end

    def have_cache_control(*directives)
      ::APIMatchers::Headers::HaveCacheControl.new(*directives)
    end

    # Pagination Matchers
    def be_paginated
      ::APIMatchers::Pagination::BePaginated.new
    end

    def have_pagination_links(*link_types)
      ::APIMatchers::Pagination::HavePaginationLinks.new(*link_types)
    end

    def have_total_count(expected_count)
      ::APIMatchers::Pagination::HaveTotalCount.new(expected_count)
    end

    # Error Response Matchers
    def have_error
      ::APIMatchers::ErrorResponse::HaveError.new
    end
    alias :have_errors :have_error

    def have_error_on(field)
      ::APIMatchers::ErrorResponse::HaveErrorOn.new(field)
    end

    # JSON:API Matchers
    def be_json_api_compliant
      ::APIMatchers::JsonApi::BeJsonApiCompliant.new
    end

    def have_json_api_data
      ::APIMatchers::JsonApi::HaveJsonApiData.new
    end

    def have_json_api_attributes(*attributes)
      ::APIMatchers::JsonApi::HaveJsonApiAttributes.new(*attributes)
    end

    def have_json_api_relationships(*relationships)
      ::APIMatchers::JsonApi::HaveJsonApiRelationships.new(*relationships)
    end

    # HATEOAS Matchers
    def have_link(rel)
      ::APIMatchers::Hateoas::HaveLink.new(rel)
    end
  end
end
