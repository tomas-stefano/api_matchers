module APIMatchers
  module ResponseBody
    class Base
      attr_reader :setup, :expected_node, :actual
      attr_writer :actual

      def initialize(options={})
        @expected_node = options.fetch(:expected_node)
        @setup = options.fetch(:setup)
      end

      def matches?(actual)
        raise NotImplementedError, "not implemented on #{self}"
      end

      def with(expected_value)
        @with_value = expected_value
        self
      end

      def response_body
        if @setup.response_body_method.present?
          @actual.send(@setup.response_body_method)
        else
          @actual
        end
      end

      def failure_message_for_should
        "expected to have node called: '#{@expected_node}'" << added_message << ". Got: '#{response_body}'"
      end

      def failure_message_for_should_not
        "expected to NOT have node called: '#{@expected_node}'" << added_message << ". Got: '#{response_body}'"
      end

      def added_message
        if @with_value
          " with value: '#{@with_value}'"
        else
          ""
        end
      end
    end
  end
end
