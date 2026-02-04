# frozen_string_literal: true

module APIMatchers
  module HTTPStatus
    class BeUnprocessable < Base
      protected

      def expected_status_match?
        actual_status.to_i == 422
      end

      def expectation_description
        "be unprocessable (422)"
      end
    end
  end
end
