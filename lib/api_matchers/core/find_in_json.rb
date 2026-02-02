# frozen_string_literal: true

module APIMatchers
  module Core
    class FindInJSON
      attr_reader :json

      def initialize(json)
        @json = json
      end

      def find(options = {})
        expected_key = options.fetch(:node).to_s
        expected_value = ValueNormalizer.normalize(options[:value])

        result = search(json, expected_key, expected_value)
        return result[:value] if result[:found]

        raise ::APIMatchers::Core::Exceptions::KeyNotFound, "key '#{expected_key}' was not found"
      end

      def available_keys
        collect_keys(json)
      end

      private

      def search(data, expected_key, expected_value)
        case data
        when Hash
          search_in_hash(data, expected_key, expected_value)
        when Array
          search_in_array(data, expected_key, expected_value)
        else
          { found: false }
        end
      end

      def search_in_hash(hash, expected_key, expected_value)
        hash.each do |key, value|
          if key.to_s == expected_key
            if expected_value.nil? || value == expected_value
              return { found: true, value: value }
            end
          end

          result = search(value, expected_key, expected_value)
          return result if result[:found]
        end

        { found: false }
      end

      def search_in_array(array, expected_key, expected_value)
        array.each do |element|
          result = search(element, expected_key, expected_value)
          return result if result[:found]
        end

        { found: false }
      end

      def collect_keys(data, keys = [])
        case data
        when Hash
          data.each do |key, value|
            keys << key.to_s
            collect_keys(value, keys)
          end
        when Array
          data.each { |element| collect_keys(element, keys) }
        end
        keys.uniq
      end
    end
  end
end