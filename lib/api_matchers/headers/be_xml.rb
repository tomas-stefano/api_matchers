module APIMatchers
  module Headers
    class BeXML < Base
      def expected_content_type
        'application/xml; charset=utf-8'
      end

      def failure_message_for_should
        %Q{expected a XML response with '#{expected_content_type}'. Got: '#{content_type_response}'.}
      end

      def failure_message_for_should_not
        %Q{expected to not be a XML response. Got: '#{expected_content_type}'.}
      end
    end
  end
end