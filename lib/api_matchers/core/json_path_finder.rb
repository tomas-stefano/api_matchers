# frozen_string_literal: true

module APIMatchers
  module Core
    class JsonPathFinder
      attr_reader :json

      def initialize(json)
        @json = json
      end

      # Navigate JSON using dot-notation paths
      # Example: "user.address.city" navigates to json["user"]["address"]["city"]
      # Supports array indexing: "users.0.name" or "users[0].name"
      def find(path)
        return json if path.nil? || path.empty?

        segments = parse_path(path)
        navigate(json, segments, path)
      end

      # Check if a path exists in the JSON
      def path_exists?(path)
        find(path)
        true
      rescue ::APIMatchers::Core::Exceptions::PathNotFound
        false
      end

      private

      def parse_path(path)
        # Handle both "items.0.name" and "items[0].name" syntax
        path.to_s.gsub(/\[(\d+)\]/, '.\1').split('.')
      end

      def navigate(data, segments, full_path)
        return data if segments.empty?

        segment = segments.first
        remaining = segments[1..]

        value = access_segment(data, segment, full_path)
        navigate(value, remaining, full_path)
      end

      def access_segment(data, segment, full_path)
        case data
        when Hash
          access_hash(data, segment, full_path)
        when Array
          access_array(data, segment, full_path)
        else
          raise ::APIMatchers::Core::Exceptions::PathNotFound,
                "Cannot navigate path '#{full_path}': '#{segment}' is not accessible on #{data.class}"
        end
      end

      def access_hash(hash, key, full_path)
        # Try both string and symbol keys
        if hash.key?(key)
          hash[key]
        elsif hash.key?(key.to_sym)
          hash[key.to_sym]
        else
          raise ::APIMatchers::Core::Exceptions::PathNotFound,
                "Path '#{full_path}' not found: key '#{key}' does not exist"
        end
      end

      def access_array(array, index_str, full_path)
        unless index_str.match?(/\A\d+\z/)
          raise ::APIMatchers::Core::Exceptions::PathNotFound,
                "Path '#{full_path}' not found: '#{index_str}' is not a valid array index"
        end

        index = index_str.to_i
        if index >= array.length
          raise ::APIMatchers::Core::Exceptions::PathNotFound,
                "Path '#{full_path}' not found: index #{index} out of bounds (array size: #{array.length})"
        end

        array[index]
      end
    end
  end
end
