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

        node = Core::FindInJSON.new(json).find(node: @expected_node.to_s)

        if @with_value
          node.to_s == @with_value.to_s
        else
          node.present?
        end
      end
    end
  end
end