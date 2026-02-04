# frozen_string_literal: true

require 'json'

module APIMatchers
  module ResponseBody
    class MatchJsonSchema
      attr_reader :schema, :actual

      def initialize(options = {})
        @schema = options.fetch(:schema)
        @errors = []
      end

      def setup
        ::APIMatchers::Core::Setup
      end

      def matches?(actual)
        @actual = actual

        unless json_schemer_available?
          raise LoadError, "json_schemer gem is required for JSON schema validation. Add it to your Gemfile: gem 'json_schemer'"
        end

        schemer = JSONSchemer.schema(normalize_schema(@schema))
        result = schemer.validate(parsed_json)
        @errors = result.to_a

        @errors.empty?
      end

      def failure_message
        error_details = @errors.first(5).map do |error|
          "  - #{error['error']} at #{error['data_pointer'].presence || 'root'}"
        end.join("\n")

        more = @errors.size > 5 ? "\n  ... and #{@errors.size - 5} more errors" : ""

        "Expected JSON to match schema.\nErrors:\n#{error_details}#{more}\n\nResponse: #{response_body}"
      end

      def failure_message_when_negated
        "Expected JSON to NOT match schema, but it did.\n\nResponse: #{response_body}"
      end

      private

      def json_schemer_available?
        require 'json_schemer'
        true
      rescue LoadError
        false
      end

      def response_body
        if setup.response_body_method.present?
          @actual.send(setup.response_body_method)
        else
          @actual
        end
      end

      def parsed_json
        body = response_body
        body.is_a?(String) ? JSON.parse(body) : body
      rescue JSON::ParserError => e
        raise ::APIMatchers::InvalidJSON, "Invalid JSON: '#{body}'"
      end

      def normalize_schema(schema)
        case schema
        when Hash
          deep_stringify_keys(schema)
        when String
          JSON.parse(schema)
        else
          schema
        end
      end

      def deep_stringify_keys(hash)
        hash.each_with_object({}) do |(key, value), result|
          result[key.to_s] = value.is_a?(Hash) ? deep_stringify_keys(value) : value
        end
      end
    end
  end
end
