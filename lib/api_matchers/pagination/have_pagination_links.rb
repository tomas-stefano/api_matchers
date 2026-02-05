# frozen_string_literal: true

module APIMatchers
  module Pagination
    class HavePaginationLinks < Base
      VALID_LINK_TYPES = %w[next prev previous first last self].freeze

      def initialize(*link_types)
        @expected_links = normalize_link_types(link_types.flatten)
      end

      def failure_message
        links = safe_json_at_path(links_path)

        if links.nil?
          "expected response to have pagination links at '#{links_path}', " \
            "but no links were found. Got: #{truncate_json(parsed_json)}"
        else
          missing = @expected_links - actual_link_types(links)
          "expected pagination links to include #{@expected_links.inspect}. " \
            "Missing: #{missing.inspect}. Available: #{actual_link_types(links).inspect}"
        end
      end

      def failure_message_when_negated
        "expected response NOT to have pagination links #{@expected_links.inspect}, " \
          "but they were present"
      end

      def description
        "have pagination links #{@expected_links.inspect}"
      end

      protected

      def perform_match
        links = safe_json_at_path(links_path)
        return false unless links.is_a?(Hash)

        actual_links = actual_link_types(links)
        @expected_links.all? { |link| actual_links.include?(link) }
      end

      private

      def normalize_link_types(types)
        types.map do |t|
          normalized = t.to_s.downcase
          normalized = 'prev' if normalized == 'previous'
          normalized
        end
      end

      def actual_link_types(links)
        links.keys.map do |k|
          normalized = k.to_s.downcase
          normalized = 'prev' if normalized == 'previous'
          normalized
        end
      end

      def safe_json_at_path(path)
        json_at_path(path)
      rescue ::APIMatchers::Core::Exceptions::PathNotFound
        nil
      end

      def truncate_json(json)
        str = json.to_json
        str.length > 200 ? "#{str[0..200]}..." : str
      end
    end
  end
end
