# frozen_string_literal: true

module APIMatchers
  module JsonStructure
    class HaveJsonKeys < Base
      def initialize(*keys)
        @expected_keys = keys.flatten.map(&:to_s)
        @path = nil
      end

      def at_path(path)
        @path = path
        self
      end

      def failure_message
        "expected JSON to have keys: #{@expected_keys.inspect}. " \
          "Missing: #{missing_keys.inspect}. " \
          "Got keys: #{actual_keys.inspect}"
      end

      def failure_message_when_negated
        "expected JSON NOT to have keys: #{@expected_keys.inspect}, but all were present"
      end

      def description
        desc = "have JSON keys #{@expected_keys.inspect}"
        desc += " at path '#{@path}'" if @path
        desc
      end

      protected

      def perform_match
        @json_data = json_at_path(@path)
        return false unless @json_data.is_a?(Hash)

        missing_keys.empty?
      rescue ::APIMatchers::Core::Exceptions::PathNotFound
        @json_data = nil
        false
      end

      private

      def actual_keys
        @json_data.is_a?(Hash) ? @json_data.keys.map(&:to_s) : []
      end

      def missing_keys
        @expected_keys - actual_keys
      end
    end
  end
end
