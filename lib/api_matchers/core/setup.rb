# frozen_string_literal: true

module APIMatchers
  module Core
    class Setup
      # The response body method that will be called when you call the have_node matchers
      #
      # ==== Examples
      #
      #  response.body.should have_node(:foo)
      #  response.body.should have_node(:bar)
      #  response.body.should have_node(:baz)
      #
      #  # Instead calling #body everytime, you can configure:
      #
      #  APIMatchers.setup do |config|
      #    config.response_body_method = :body
      #  end
      #
      # Then:
      #
      #  response.should have_node(:foo)
      #  response.should have_node(:bar)
      #  response.should have_node(:baz)
      #
      cattr_accessor :response_body_method

      # The default have node matcher that will be used.
      # This have_node matcher is useful when you just work with one content type in your API.
      # Change to :xml if you want that have_node works ONLY with XML.
      # If you work with xml and json in the same API, I recommend that you check the
      # have_json_node and have_xml_node matchers.
      #
      cattr_accessor :have_node_matcher
      self.have_node_matcher = :json

      # The headers method and the content type key that will be used by the headers matchers.
      #
      # ==== Examples
      #
      #  response.response_header['Content-Type'].should be_json
      #  response.response_header['Content-Type'].should be_xml
      #
      #  # Instead calling #response_header everytime, you can configure:
      #
      #  APIMatchers.setup do |config|
      #    config.header_method = :response_header
      #    config.header_content_type_key = 'Content-Type'
      #  end
      #
      # Then:
      #
      #  response.should be_json
      #  response.should be_xml
      #
      cattr_accessor :header_method
      cattr_accessor :header_content_type_key

      # HTTP status method - for extracting status codes from response objects
      #
      # ==== Examples
      #
      #  APIMatchers.setup do |config|
      #    config.http_status_method = :status  # or :code, :status_code
      #  end
      #
      cattr_accessor :http_status_method

      # Pagination configuration
      #
      # ==== Examples
      #
      #  APIMatchers.setup do |config|
      #    config.pagination_meta_path = 'meta'           # path to pagination metadata
      #    config.pagination_links_path = 'links'         # path to pagination links
      #  end
      #
      cattr_accessor :pagination_meta_path
      cattr_accessor :pagination_links_path

      # Error response configuration
      #
      # ==== Examples
      #
      #  APIMatchers.setup do |config|
      #    config.errors_path = 'errors'                  # path to errors array
      #    config.error_message_key = 'message'           # key for error message
      #    config.error_field_key = 'field'               # key for error field name
      #  end
      #
      cattr_accessor :errors_path
      cattr_accessor :error_message_key
      cattr_accessor :error_field_key

      # HATEOAS links configuration
      #
      # ==== Examples
      #
      #  APIMatchers.setup do |config|
      #    config.links_path = '_links'                   # path to HATEOAS links (HAL style)
      #  end
      #
      cattr_accessor :links_path
    end
  end
end