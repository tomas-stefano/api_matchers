# frozen_string_literal: true

module APIMatchers
  module Headers
    class HaveCacheControl
      VALID_DIRECTIVES = %w[
        public private no-cache no-store no-transform must-revalidate
        proxy-revalidate max-age s-maxage immutable stale-while-revalidate
        stale-if-error
      ].freeze

      attr_reader :actual

      def initialize(*directives)
        @expected_directives = normalize_directives(directives.flatten)
      end

      def setup
        ::APIMatchers::Core::Setup
      end

      def matches?(actual)
        @actual = actual
        cache_control = fetch_cache_control
        return false if cache_control.nil?

        @actual_directives = parse_cache_control(cache_control)

        @expected_directives.all? do |directive|
          @actual_directives.include?(directive) ||
            @actual_directives.any? { |d| d.start_with?("#{directive}=") }
        end
      end

      def failure_message
        cache_control = fetch_cache_control

        if cache_control.nil?
          "expected response to have Cache-Control header with #{@expected_directives.inspect}, " \
            "but Cache-Control header was not present"
        else
          "expected Cache-Control to include #{@expected_directives.inspect}. " \
            "Got: '#{cache_control}' (parsed: #{@actual_directives.inspect})"
        end
      end

      def failure_message_when_negated
        "expected Cache-Control NOT to include #{@expected_directives.inspect}, " \
          "but it did: '#{fetch_cache_control}'"
      end

      def description
        "have Cache-Control with #{@expected_directives.inspect}"
      end

      private

      def normalize_directives(directives)
        directives.map do |d|
          d.to_s.tr('_', '-')
        end
      end

      def fetch_cache_control
        headers = available_headers
        return nil unless headers

        headers['Cache-Control'] ||
          headers['cache-control'] ||
          headers.find { |k, _| k.to_s.downcase == 'cache-control' }&.last
      end

      def parse_cache_control(value)
        value.to_s.split(',').map(&:strip).map(&:downcase)
      end

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
    end
  end
end
