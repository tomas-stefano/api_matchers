# frozen_string_literal: true

module APIMatchers
  module JsonApi
    class HaveJsonApiData < Base
      def initialize
        @expected_type = nil
        @expected_id = nil
      end

      def of_type(type)
        @expected_type = type.to_s
        self
      end

      def with_id(id)
        @expected_id = id.to_s
        self
      end

      def failure_message
        data = json_api_data

        if data.nil? && !parsed_json.key?('data') && !parsed_json.key?(:data)
          "expected response to have JSON:API data. Got: #{truncate_json(parsed_json)}"
        elsif @expected_type && !type_matches?(data)
          "expected JSON:API data to have type '#{@expected_type}'. " \
            "Got type: '#{extract_type(data)}'"
        elsif @expected_id && !id_matches?(data)
          "expected JSON:API data to have id '#{@expected_id}'. " \
            "Got id: '#{extract_id(data)}'"
        else
          "expected response to have JSON:API data"
        end
      end

      def failure_message_when_negated
        if @expected_type || @expected_id
          "expected JSON:API data NOT to have " \
            "#{[@expected_type && "type '#{@expected_type}'", @expected_id && "id '#{@expected_id}'"].compact.join(' and ')}, " \
            "but it did"
        else
          "expected response NOT to have JSON:API data, but it did"
        end
      end

      def description
        desc = "have JSON:API data"
        desc += " of type '#{@expected_type}'" if @expected_type
        desc += " with id '#{@expected_id}'" if @expected_id
        desc
      end

      protected

      def perform_match
        data = json_api_data

        # data: null is valid JSON:API
        return true if data.nil? && (parsed_json.key?('data') || parsed_json.key?(:data))

        return false unless data

        if @expected_type && !type_matches?(data)
          return false
        end

        if @expected_id && !id_matches?(data)
          return false
        end

        true
      end

      private

      def type_matches?(data)
        case data
        when Hash
          extract_type(data) == @expected_type
        when Array
          data.all? { |d| extract_type(d) == @expected_type }
        else
          false
        end
      end

      def id_matches?(data)
        case data
        when Hash
          extract_id(data) == @expected_id
        when Array
          data.any? { |d| extract_id(d) == @expected_id }
        else
          false
        end
      end

      def extract_type(resource)
        return nil unless resource.is_a?(Hash)
        (resource['type'] || resource[:type])&.to_s
      end

      def extract_id(resource)
        return nil unless resource.is_a?(Hash)
        (resource['id'] || resource[:id])&.to_s
      end
    end
  end
end
