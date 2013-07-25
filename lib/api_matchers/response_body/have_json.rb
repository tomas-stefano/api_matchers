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

      def failure_message_for_should
        "expect to have json: '#{response_body}'. Got: '#{json}'."
      end

      def failure_message_for_should_not
        "expect to NOT have json: '#{response_body}'."
      end
    end
  end
end

