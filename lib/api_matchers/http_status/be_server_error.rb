# frozen_string_literal: true

module APIMatchers
  module HTTPStatus
    class BeServerError < Base
      protected

      def expected_status_match?
        ::APIMatchers::Core::HTTPStatusCodes.server_error?(actual_status)
      end

      def expectation_description
        "be server error (5xx)"
      end
    end
  end
end
