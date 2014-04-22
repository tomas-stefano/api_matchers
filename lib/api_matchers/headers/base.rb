module APIMatchers
  module Headers
    class Base
      attr_reader :setup

      def initialize(setup)
        @setup = setup
      end

      def matches?(actual)
        @actual = actual

        content_type_response.eql?(expected_content_type)
      end

      def content_type_response
        if @setup.header_method.present? and @setup.header_content_type_key.present?
          headers = @actual.send(@setup.header_method)
          if headers.present?
            headers[@setup.header_content_type_key] || headers
          end
        else
          @actual
        end
      end

      def expected_content_type
        raise NotImplementedError, "not implemented on #{self}"
      end
    end
  end
end
