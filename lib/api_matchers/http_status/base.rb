# frozen_string_literal: true

module APIMatchers
  module HTTPStatus
    class Base
      attr_reader :actual

      def setup
        ::APIMatchers::Core::Setup
      end

      def matches?(actual)
        @actual = actual
        expected_status_match?
      end

      def failure_message
        "expected response to #{expectation_description}. Got: #{actual_status}"
      end

      def failure_message_when_negated
        "expected response NOT to #{expectation_description}. Got: #{actual_status}"
      end

      def description
        expectation_description
      end

      protected

      def expected_status_match?
        raise NotImplementedError, "Subclasses must implement #expected_status_match?"
      end

      def expectation_description
        raise NotImplementedError, "Subclasses must implement #expectation_description"
      end

      def actual_status
        if setup.http_status_method.present?
          @actual.send(setup.http_status_method)
        else
          @actual
        end
      end
    end
  end
end
