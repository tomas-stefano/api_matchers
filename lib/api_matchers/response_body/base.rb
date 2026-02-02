# frozen_string_literal: true

module APIMatchers
  module ResponseBody
    class Base
      attr_reader :setup, :expected_node, :actual
      attr_writer :actual

      def initialize(options = {})
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

      def including_text(expected_including_text)
        @expected_including_text = expected_including_text
        self
      end

      def response_body
        if @setup.response_body_method.present?
          @actual.send(@setup.response_body_method)
        else
          @actual
        end
      end

      def failure_message
        "expected to have node called: '#{@expected_node}'" << added_message << ". Got: '#{response_body}'"
      end

      def failure_message_when_negated
        "expected to NOT have node called: '#{@expected_node}'" << added_message << ". Got: '#{response_body}'"
      end

      def added_message
        if @with_value
          " with value: '#{@with_value}'"
        elsif @expected_including_text
          " including text: '#{@expected_including_text}'"
        else
          ""
        end
      end
    end
  end
end
