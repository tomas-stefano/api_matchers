# frozen_string_literal: true

module APIMatchers
  module Headers
    class HaveCorsHeaders
      CORS_HEADERS = %w[
        Access-Control-Allow-Origin
      ].freeze

      OPTIONAL_CORS_HEADERS = %w[
        Access-Control-Allow-Methods
        Access-Control-Allow-Headers
        Access-Control-Allow-Credentials
        Access-Control-Expose-Headers
        Access-Control-Max-Age
      ].freeze

      attr_reader :actual

      def initialize
        @expected_origin = nil
      end

      def setup
        ::APIMatchers::Core::Setup
      end

      def for_origin(origin)
        @expected_origin = origin
        self
      end

      def matches?(actual)
        @actual = actual
        headers = available_headers
        return false unless headers

        has_required_headers = CORS_HEADERS.all? { |h| header_present?(headers, h) }
        return false unless has_required_headers

        if @expected_origin
          origin_value = fetch_header(headers, 'Access-Control-Allow-Origin')
          return false unless origin_value == @expected_origin || origin_value == '*'
        end

        true
      end

      def failure_message
        headers = available_headers
        missing = CORS_HEADERS.reject { |h| header_present?(headers, h) }

        if missing.any?
          "expected response to have CORS headers. Missing: #{missing.inspect}. " \
            "Available headers: #{headers&.keys&.inspect}"
        elsif @expected_origin
          origin_value = fetch_header(headers, 'Access-Control-Allow-Origin')
          "expected Access-Control-Allow-Origin to be '#{@expected_origin}' or '*'. " \
            "Got: '#{origin_value}'"
        else
          "expected response to have CORS headers"
        end
      end

      def failure_message_when_negated
        "expected response NOT to have CORS headers, but they were present"
      end

      def description
        desc = "have CORS headers"
        desc += " for origin '#{@expected_origin}'" if @expected_origin
        desc
      end

      private

      def available_headers
        if setup.header_method.present?
          @actual.send(setup.header_method)
        elsif @actual.respond_to?(:headers)
          @actual.headers
        elsif @actual.is_a?(Hash)
          @actual
        else
          {}
        end
      end

      def header_present?(headers, name)
        fetch_header(headers, name) != nil
      end

      def fetch_header(headers, name)
        return nil unless headers

        headers[name] ||
          headers[name.downcase] ||
          headers.find { |k, _| k.to_s.downcase == name.downcase }&.last
      end
    end
  end
end
