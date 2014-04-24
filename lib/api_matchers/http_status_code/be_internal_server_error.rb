module APIMatchers
  module HTTPStatusCode
    class BeInternalServerError < Base
      def expected_status_code
        500
      end

      def failure_message
        %Q{expected that '#{@http_status_code}' to be Internal Server Error with the status '500'.}
      end

      def failure_message_when_negated
        %Q{expected that '#{@http_status_code}' to NOT be Internal Server Error.}
      end

      # RSpec 2 compatibility:
      alias_method :failure_message_for_should, :failure_message
      alias_method :failure_message_for_should_not, :failure_message_when_negated
    end
  end
end
