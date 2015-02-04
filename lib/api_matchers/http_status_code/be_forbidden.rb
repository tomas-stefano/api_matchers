module APIMatchers
  module HTTPStatusCode
    class BeForbidden < Base
      def expected_status_code
        403
      end

      def failure_message
        %Q{expected that '#{@http_status_code}' to be Forbidden with the status '403'.}
      end

      def failure_message_when_negated
        %Q{expected that '#{@http_status_code}' to NOT be Forbidden.}
      end

      # RSpec 2 compatibility:
      alias_method :failure_message_for_should, :failure_message
      alias_method :failure_message_for_should_not, :failure_message_when_negated
    end
  end
end