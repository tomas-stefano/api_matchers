module APIMatchers
  module RSpecMatchers
    def be_bad_request
      ::APIMatchers::HTTPStatusCode::BeBadRequest.new(::APIMatchers::Core::Setup)
    end
    alias :be_a_bad_request :be_bad_request

    def be_not_found
      ::APIMatchers::HTTPStatusCode::BeNotFound.new(::APIMatchers::Core::Setup)
    end

    def be_internal_server_error
      ::APIMatchers::HTTPStatusCode::BeInternalServerError.new(::APIMatchers::Core::Setup)
    end
    alias :be_an_internal_server_error :be_internal_server_error

    def be_unauthorized
      ::APIMatchers::HTTPStatusCode::BeUnauthorized.new(::APIMatchers::Core::Setup)
    end

    def be_ok
      ::APIMatchers::HTTPStatusCode::BeOk.new(::APIMatchers::Core::Setup)
    end

    def create_resource
      ::APIMatchers::HTTPStatusCode::CreateResource.new(::APIMatchers::Core::Setup)
    end
    alias :created_resource :create_resource

    def be_xml
      ::APIMatchers::Headers::BeXML.new(::APIMatchers::Core::Setup)
    end
    alias :be_in_xml :be_xml

    def be_json
      ::APIMatchers::Headers::BeJSON.new(::APIMatchers::Core::Setup)
    end
    alias :be_in_json :be_json
    alias :be_a_json  :be_json

    def have_json_node(expected_node)
      ::APIMatchers::ResponseBody::HaveJsonNode.new(expected_node: expected_node, setup: ::APIMatchers::Core::Setup)
    end

    def have_xml_node(expected_node)
      ::APIMatchers::ResponseBody::HaveXmlNode.new(expected_node: expected_node, setup: ::APIMatchers::Core::Setup)
    end

    def have_node(expected_node)
      if ::APIMatchers::Core::Setup.have_node_matcher.equal?(:json)
        have_json_node(expected_node)
      else
        have_xml_node(expected_node)
      end
    end
  end
end