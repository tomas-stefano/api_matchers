module APIMatchers
  module HTTPStatusCode
    class BeUnauthorized < Base
      def expected_status_code
        401
      end

      def failure_message_for_should
        %Q{expected that '#{@http_status_code}' to be Unauthorized with the status '401'.}
      end

      def failure_message_for_should_not
        %Q{expected that '#{@http_status_code}' to NOT be Unauthorized.}
      end
    end
  end
end