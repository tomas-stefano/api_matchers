# frozen_string_literal: true

require 'json'

module APIMatchers
  module JsonStructure
    class Base
      attr_reader :actual

      def setup
        ::APIMatchers::Core::Setup
      end

      def matches?(actual)
        @actual = actual
        perform_match
      end

      def failure_message
        raise NotImplementedError, "Subclasses must implement #failure_message"
      end

      def failure_message_when_negated
        raise NotImplementedError, "Subclasses must implement #failure_message_when_negated"
      end

      protected

      def perform_match
        raise NotImplementedError, "Subclasses must implement #perform_match"
      end

      def response_body
        if setup.response_body_method.present?
          @actual.send(setup.response_body_method)
        else
          @actual
        end
      end

      def parsed_json
        @parsed_json ||= begin
          body = response_body
          case body
          when Hash, Array
            body
          when String
            JSON.parse(body)
          else
            raise ::APIMatchers::InvalidJSON, "Invalid JSON: '#{body}'"
          end
        end
      rescue JSON::ParserError
        raise ::APIMatchers::InvalidJSON, "Invalid JSON: '#{response_body}'"
      end

      def json_at_path(path)
        return parsed_json if path.nil? || path.empty?

        finder = ::APIMatchers::Core::JsonPathFinder.new(parsed_json)
        finder.find(path)
      end
    end
  end
end
