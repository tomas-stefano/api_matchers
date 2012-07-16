module APIMatchers
  module Headers
    class BeJSON < Base
      def expected_content_type
        'application/json; charset=utf-8'
      end

      def failure_message_for_should
        %Q{expected a JSON response with '#{expected_content_type}'. Got: '#{@actual}'.}
      end

      def failure_message_for_should_not
        %Q{expected to not be a JSON response. Got: '#{expected_content_type}'.}
      end
    end
  end
end