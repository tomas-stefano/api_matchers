# frozen_string_literal: true

module APIMatchers
  module JsonStructure
    class HaveJsonType < Base
      TYPE_MAP = {
        Integer => [Integer],
        Float => [Float],
        Numeric => [Integer, Float],
        String => [String],
        TrueClass => [TrueClass],
        FalseClass => [FalseClass],
        :boolean => [TrueClass, FalseClass],
        Array => [Array],
        Hash => [Hash],
        NilClass => [NilClass]
      }.freeze

      def initialize(expected_type)
        @expected_type = expected_type
        @path = nil
      end

      def at_path(path)
        @path = path
        self
      end

      def failure_message
        "expected JSON value at '#{@path || 'root'}' to be of type #{expected_type_name}. " \
          "Got: #{@value.inspect} (#{@value.class})"
      end

      def failure_message_when_negated
        "expected JSON value at '#{@path || 'root'}' NOT to be of type #{expected_type_name}. " \
          "Got: #{@value.inspect} (#{@value.class})"
      end

      def description
        desc = "have JSON type #{expected_type_name}"
        desc += " at path '#{@path}'" if @path
        desc
      end

      protected

      def perform_match
        @value = json_at_path(@path)
        type_matches?
      rescue ::APIMatchers::Core::Exceptions::PathNotFound
        @value = nil
        false
      end

      private

      def type_matches?
        allowed_types = TYPE_MAP[@expected_type] || [@expected_type]
        allowed_types.any? { |type| @value.is_a?(type) }
      end

      def expected_type_name
        case @expected_type
        when :boolean
          "Boolean"
        else
          @expected_type.to_s
        end
      end
    end
  end
end
