module APIMatchers
  module HTTPStatusCode
    class BeNotFound < Base
      def expected_status_code
        404
      end

      def failure_message_for_should
        %Q{expected that '#{@http_status_code}' to be Not Found with the status '404'.}
      end

      def failure_message_for_should_not
        %Q{expected that '#{@http_status_code}' to NOT be Not Found with the status '404'.}
      end
    end
  end
end