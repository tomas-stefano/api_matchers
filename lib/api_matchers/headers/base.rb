module APIMatchers
  module Headers
    class Base
      def matches?(actual)
        @actual = actual
        actual.eql?(expected_content_type)
      end

      def expected_content_type
        raise NotImplementedError, "not implemented on #{self}"
      end
    end
  end
end