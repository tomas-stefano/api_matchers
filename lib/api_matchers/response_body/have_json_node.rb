# frozen_string_literal: true

require 'json'
require 'active_support/core_ext/hash'

module APIMatchers
  module ResponseBody
    class HaveJsonNode < Base
      include APIMatchers::Core::Parser

      def matches?(actual)
        @actual = actual

        begin
          @finder = Core::FindInJSON.new(json)
          node = @finder.find(node: @expected_node.to_s, value: @with_value)

          if @expected_including_text
            node.to_s.include?(@expected_including_text)
          elsif @including_matcher
            match_including(node)
          elsif @including_all_matcher
            match_including_all(node)
          else
            true # the node is present
          end
        rescue ::APIMatchers::KeyNotFound
          false # the key was not found
        end
      end

      def including(expected_element)
        @including_matcher = expected_element
        self
      end

      def including_all(expected_elements)
        @including_all_matcher = expected_elements
        self
      end

      private

      def match_including(node)
        return false unless node.is_a?(Array)

        node.any? { |element| element_matches?(element, @including_matcher) }
      end

      def match_including_all(node)
        return false unless node.is_a?(Array)

        @including_all_matcher.all? do |expected|
          node.any? { |element| element_matches?(element, expected) }
        end
      end

      def element_matches?(element, expected)
        case expected
        when Hash
          expected.all? do |key, value|
            element.is_a?(Hash) && element[key.to_s] == value
          end
        else
          element == expected
        end
      end
    end
  end
end