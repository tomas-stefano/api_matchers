require 'json'
require 'active_support/core_ext/hash'

module APIMatchers
  module ResponseBody
    class HaveJsonNode < Base
      include APIMatchers::Core::Parser

      def matches?(actual)
        @actual = actual

        begin
          node = Core::FindInJSON.new(json).find(node: @expected_node.to_s, value: @with_value)

          if @expected_including_text
            node.to_s.include?(@expected_including_text)
          else
            true # the node is present
          end
        rescue ::APIMatchers::KeyNotFound
          false # the key was not found
        end
      end
    end
  end
end