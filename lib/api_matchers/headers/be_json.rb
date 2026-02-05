# frozen_string_literal: true

module APIMatchers
  module Headers
    class BeJSON < Base
      def expected_content_type
        'application/json; charset=utf-8'
      end

      def failure_message
        %Q{expected a JSON response with '#{expected_content_type}'. Got: '#{content_type_response}'.}
      end

      def failure_message_when_negated
        %Q{expected to not be a JSON response. Got: '#{expected_content_type}'.}
      end

      def description
        "be in JSON"
      end
    end
  end
end
