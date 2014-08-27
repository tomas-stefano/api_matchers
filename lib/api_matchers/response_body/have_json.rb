module APIMatchers
  module ResponseBody
    class HaveJson
      include APIMatchers::Core::Parser
      attr_reader :expected_json, :response_body

      def initialize(expected_json)
        @expected_json = expected_json
      end

      def matches?(actual)
        @response_body = actual

        @expected_json == json
      end

      def failure_message
        "expect to have json: '#{expected_json}'. Got: '#{json}'."
      end

      def failure_message_when_negated
        "expect to NOT have json: '#{response_body}'."
      end

      # RSpec 2 compatibility:
      alias_method :failure_message_for_should, :failure_message
      alias_method :failure_message_for_should_not, :failure_message_when_negated
    end
  end
end
