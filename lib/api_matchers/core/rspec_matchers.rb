# frozen_string_literal: true

module APIMatchers
  module RSpecMatchers
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
      ::APIMatchers::ResponseBody::MatchJsonSchema.new(schema: schema, setup: ::APIMatchers::Core::Setup)
    end
  end
end