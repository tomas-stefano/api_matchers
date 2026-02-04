# frozen_string_literal: true

module APIMatchers
  module HTTPStatus
    class HaveHttpStatus < Base
      def initialize(expected)
        @expected = expected
      end

      protected

      def expected_status_match?
        actual_status.to_i == expected_code
      end

      def expectation_description
        if @expected.is_a?(Symbol)
          "have HTTP status #{expected_code} (#{@expected})"
        else
          "have HTTP status #{expected_code}"
        end
      end

      private

      def expected_code
        case @expected
        when Symbol
          ::APIMatchers::Core::HTTPStatusCodes.symbol_to_code(@expected) ||
            raise(ArgumentError, "Unknown status code symbol: #{@expected}")
        when Integer
          @expected
        else
          raise ArgumentError, "Expected status must be a Symbol or Integer, got: #{@expected.class}"
        end
      end
    end
  end
end
