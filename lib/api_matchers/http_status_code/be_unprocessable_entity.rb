module APIMatchers
  module HTTPStatusCode
    class BeUnprocessableEntity < Base
      def expected_status_code
        422
      end

      def failure_message
        %Q{expected that '#{@http_status_code}' to be Unprocessable entity with the status '#{expected_status_code}'.}
      end

      def failure_message_when_negated
        %Q{expected that '#{@http_status_code}' to NOT be Unprocessable entity with the status '#{expected_status_code}'.}
      end

      def description
        "be Unprocessable entity with the status '422'"
      end

      # RSpec 2 compatibility:
      alias_method :failure_message_for_should, :failure_message
      alias_method :failure_message_for_should_not, :failure_message_when_negated
    end
  end
end
