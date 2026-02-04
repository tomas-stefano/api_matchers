# frozen_string_literal: true

module APIMatchers
  module HTTPStatus
    class BeClientError < Base
      protected

      def expected_status_match?
        ::APIMatchers::Core::HTTPStatusCodes.client_error?(actual_status)
      end

      def expectation_description
        "be client error (4xx)"
      end
    end
  end
end
