# frozen_string_literal: true

module APIMatchers
  module Pagination
    class BePaginated < Base
      COMMON_PAGINATION_KEYS = %w[
        page per_page total total_pages total_count
        current_page next_page prev_page
        offset limit count
      ].freeze

      def failure_message
        "expected response to be paginated (have pagination metadata). " \
          "Looked for pagination keys at '#{meta_path}' and '#{links_path}'. " \
          "Got: #{truncate_json(parsed_json)}"
      end

      def failure_message_when_negated
        "expected response NOT to be paginated, but pagination metadata was found"
      end

      def description
        "be paginated"
      end

      protected

      def perform_match
        has_meta_pagination? || has_links_pagination? || has_root_pagination?
      end

      private

      def has_meta_pagination?
        meta = safe_json_at_path(meta_path)
        return false unless meta.is_a?(Hash)

        has_pagination_keys?(meta)
      end

      def has_links_pagination?
        links = safe_json_at_path(links_path)
        return false unless links.is_a?(Hash)

        # Check for common link keys like next, prev, first, last
        link_keys = links.keys.map(&:to_s).map(&:downcase)
        (link_keys & %w[next prev previous first last self]).any?
      end

      def has_root_pagination?
        return false unless parsed_json.is_a?(Hash)

        has_pagination_keys?(parsed_json)
      end

      def has_pagination_keys?(hash)
        keys = hash.keys.map(&:to_s).map(&:downcase)
        (keys & COMMON_PAGINATION_KEYS).any?
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
