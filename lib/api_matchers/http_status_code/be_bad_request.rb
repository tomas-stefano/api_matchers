module APIMatchers
  module HTTPStatusCode
    class BeBadRequest < Base
      def expected_status_code
        400
      end

      def failure_message_for_should
        %Q{expected that '#{@http_status_code}' to be a Bad Request with the status '400'.}
      end

      def failure_message_for_should_not
        %Q{expected that '#{@http_status_code}' to NOT be a Bad Request with the status '400'.}
      end
    end
  end
end