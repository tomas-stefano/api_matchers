module APIMatchers
  module HTTPStatusCode
    class CreateResource < Base
      def expected_status_code
        201
      end

      def failure_message
        %Q{expected that '#{@http_status_code}' to be Created Resource with the status '201'.}
      end

      def failure_message_when_negated
        %Q{expected that '#{@http_status_code}' to NOT be Created Resource.}
      end

      # RSpec 2 compatibility:
      alias_method :failure_message_for_should, :failure_message
      alias_method :failure_message_for_should_not, :failure_message_when_negated
    end
  end
end
