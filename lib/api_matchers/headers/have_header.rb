# frozen_string_literal: true

module APIMatchers
  module Headers
    class HaveHeader
      attr_reader :actual

      def initialize(header_name)
        @header_name = header_name.to_s
        @expected_value = nil
        @value_pattern = nil
      end

      def setup
        ::APIMatchers::Core::Setup
      end

      def with_value(value)
        @expected_value = value
        self
      end

      def matching(pattern)
        @value_pattern = pattern
        self
      end

      def matches?(actual)
        @actual = actual
        header_value = fetch_header_value

        return false if header_value.nil?

        if @expected_value
          header_value == @expected_value
        elsif @value_pattern
          header_value.to_s.match?(@value_pattern)
        else
          true
        end
      end

      def failure_message
        header_value = fetch_header_value

        if header_value.nil?
          "expected response to have header '#{@header_name}', but it was not present. " \
            "Available headers: #{available_headers.keys.inspect}"
        elsif @expected_value
          "expected header '#{@header_name}' to have value '#{@expected_value}'. " \
            "Got: '#{header_value}'"
        elsif @value_pattern
          "expected header '#{@header_name}' to match #{@value_pattern.inspect}. " \
            "Got: '#{header_value}'"
        else
          "expected response to have header '#{@header_name}'"
        end
      end

      def failure_message_when_negated
        if @expected_value
          "expected header '#{@header_name}' NOT to have value '#{@expected_value}', but it did"
        elsif @value_pattern
          "expected header '#{@header_name}' NOT to match #{@value_pattern.inspect}, but it did"
        else
          "expected response NOT to have header '#{@header_name}', but it was present"
        end
      end

      def description
        desc = "have header '#{@header_name}'"
        desc += " with value '#{@expected_value}'" if @expected_value
        desc += " matching #{@value_pattern.inspect}" if @value_pattern
        desc
      end

      private

      def fetch_header_value
        headers = available_headers
        return nil unless headers

        # Try exact match first, then case-insensitive
        headers[@header_name] ||
          headers[@header_name.downcase] ||
          headers.find { |k, _| k.to_s.downcase == @header_name.downcase }&.last
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
