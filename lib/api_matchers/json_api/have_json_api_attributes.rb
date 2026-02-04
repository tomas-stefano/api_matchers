# frozen_string_literal: true

module APIMatchers
  module JsonApi
    class HaveJsonApiAttributes < Base
      def initialize(*attributes)
        @expected_attributes = attributes.flatten.map(&:to_s)
      end

      def failure_message
        data = json_api_data
        attrs = extract_attributes(data)

        if attrs.nil?
          "expected JSON:API data to have attributes #{@expected_attributes.inspect}, " \
            "but no attributes were found. Got: #{truncate_json(parsed_json)}"
        else
          missing = @expected_attributes - attrs.keys.map(&:to_s)
          "expected JSON:API data to have attributes #{@expected_attributes.inspect}. " \
            "Missing: #{missing.inspect}. Available: #{attrs.keys.map(&:to_s).inspect}"
        end
      end

      def failure_message_when_negated
        "expected JSON:API data NOT to have attributes #{@expected_attributes.inspect}, " \
          "but all were present"
      end

      def description
        "have JSON:API attributes #{@expected_attributes.inspect}"
      end

      protected

      def perform_match
        data = json_api_data
        return false unless data

        attrs = extract_attributes(data)
        return false unless attrs.is_a?(Hash)

        available_attrs = attrs.keys.map(&:to_s)
        (@expected_attributes - available_attrs).empty?
      end

      private

      def extract_attributes(data)
        case data
        when Hash
          data['attributes'] || data[:attributes]
        when Array
          # For collections, check the first item
          first = data.first
          first['attributes'] || first[:attributes] if first.is_a?(Hash)
        else
          nil
        end
      end
    end
  end
end
