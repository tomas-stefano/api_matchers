module APIMatchers
  module HTTPStatusCode
    class BeOk < Base
      def expected_status_code
        200
      end

      def failure_message_for_should
        %Q{expected that '#{@http_status_code}' to be ok with the status '200'.}
      end

      def failure_message_for_should_not
        %Q{expected that '#{@http_status_code}' to NOT be ok with the status '200'.}
      end
    end
  end
end