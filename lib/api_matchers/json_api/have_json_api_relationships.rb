# frozen_string_literal: true

module APIMatchers
  module JsonApi
    class HaveJsonApiRelationships < Base
      def initialize(*relationships)
        @expected_relationships = relationships.flatten.map(&:to_s)
      end

      def failure_message
        data = json_api_data
        rels = extract_relationships(data)

        if rels.nil?
          "expected JSON:API data to have relationships #{@expected_relationships.inspect}, " \
            "but no relationships were found. Got: #{truncate_json(parsed_json)}"
        else
          missing = @expected_relationships - rels.keys.map(&:to_s)
          "expected JSON:API data to have relationships #{@expected_relationships.inspect}. " \
            "Missing: #{missing.inspect}. Available: #{rels.keys.map(&:to_s).inspect}"
        end
      end

      def failure_message_when_negated
        "expected JSON:API data NOT to have relationships #{@expected_relationships.inspect}, " \
          "but all were present"
      end

      def description
        "have JSON:API relationships #{@expected_relationships.inspect}"
      end

      protected

      def perform_match
        data = json_api_data
        return false unless data

        rels = extract_relationships(data)
        return false unless rels.is_a?(Hash)

        available_rels = rels.keys.map(&:to_s)
        (@expected_relationships - available_rels).empty?
      end

      private

      def extract_relationships(data)
        case data
        when Hash
          data['relationships'] || data[:relationships]
        when Array
          # For collections, check the first item
          first = data.first
          first['relationships'] || first[:relationships] if first.is_a?(Hash)
        else
          nil
        end
      end
    end
  end
end
