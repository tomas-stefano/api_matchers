module APIMatchers
  module HTTPStatusCode
    class Base
      attr_reader :setup

      def initialize(setup)
        @setup = setup
      end

      # Matches the actual with the expected http status code
      #
      def matches?(actual)
        @http_status_code = find_http_status_code(actual)
        @http_status_code.equal?(expected_status_code)
      end

      def expected_status_code
        raise NotImplementedError, "not implemented on #{self}"
      end

      # If have some configuration about the method to call on actual that method will be called.
      #
      def find_http_status_code(actual)
        if @setup.http_status_method.present?
          actual.send(@setup.http_status_method)
        else
          actual
        end
      end
    end
  end
end