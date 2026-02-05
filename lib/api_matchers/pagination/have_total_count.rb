# frozen_string_literal: true

module APIMatchers
  module Pagination
    class HaveTotalCount < Base
      TOTAL_COUNT_KEYS = %w[total total_count totalCount count total_items totalItems].freeze

      def initialize(expected_count)
        @expected_count = expected_count
      end

      def failure_message
        if @actual_count.nil?
          "expected response to have total count of #{@expected_count}, " \
            "but no total count field was found. " \
            "Looked for keys: #{TOTAL_COUNT_KEYS.inspect} at '#{meta_path}' and root level. " \
            "Got: #{truncate_json(parsed_json)}"
        else
          "expected total count to be #{@expected_count}. Got: #{@actual_count}"
        end
      end

      def failure_message_when_negated
        "expected total count NOT to be #{@expected_count}, but it was"
      end

      def description
        "have total count of #{@expected_count}"
      end

      protected

      def perform_match
        @actual_count = find_total_count
        @actual_count == @expected_count
      end

      private

      def find_total_count
        # First, try meta path
        meta = safe_json_at_path(meta_path)
        if meta.is_a?(Hash)
          count = find_count_in_hash(meta)
          return count unless count.nil?
        end

        # Then try root level
        if parsed_json.is_a?(Hash)
          count = find_count_in_hash(parsed_json)
          return count unless count.nil?
        end

        nil
      end

      def find_count_in_hash(hash)
        TOTAL_COUNT_KEYS.each do |key|
          value = hash[key] || hash[key.to_sym]
          return value.to_i if value
        end
        nil
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
