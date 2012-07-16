module APIMatchers
  module HTTPStatusCode
    class BeInternalServerError < Base
      def expected_status_code
        500
      end

      def failure_message_for_should
        %Q{expected that '#{@http_status_code}' to be Internal Server Error with the status '500'.}
      end

      def failure_message_for_should_not
        %Q{expected that '#{@http_status_code}' to NOT be Internal Server Error.}
      end
    end
  end
end