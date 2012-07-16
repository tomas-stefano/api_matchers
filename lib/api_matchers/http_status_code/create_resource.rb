module APIMatchers
  module HTTPStatusCode
    class CreateResource < Base
      def expected_status_code
        201
      end

      def failure_message_for_should
        %Q{expected that '#{@http_status_code}' to be Created Resource with the status '201'.}
      end

      def failure_message_for_should_not
        %Q{expected that '#{@http_status_code}' to NOT be Created Resource.}
      end
    end
  end
end