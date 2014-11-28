module APIMatchers
  module HTTPStatusCode
    class BeOk < Base
      def expected_status_code
        200
      end

      def failure_message
        %Q{expected that '#{@http_status_code}' to be ok with the status '200'.}
      end

      def failure_message_when_negated
        %Q{expected that '#{@http_status_code}' to NOT be ok with the status '200'.}
      end

      def description
        "be ok"
      end

      # RSpec 2 compatibility:
      alias_method :failure_message_for_should, :failure_message
      alias_method :failure_message_for_should_not, :failure_message_when_negated
    end
  end
end
