require 'json'
require 'active_support/core_ext/hash'

module APIMatchers
  module ResponseBody
    class HaveJsonNode < Base
      def matches?(actual)
        @actual = actual
        json = begin
          JSON.parse(response_body)
        rescue
          {}
        end

        begin
          node = Core::FindInJSON.new(json).find(node: @expected_node.to_s)

          if @with_value
            node.to_s == @with_value.to_s
          elsif @expected_including_text
            node.to_s.include?(@expected_including_text)
          else
            # the node is present
            true
          end
        rescue ::APIMatchers::Core::Exceptions::KeyNotFound
          # the key was not found
          false
        end
      end
    end
  end
end