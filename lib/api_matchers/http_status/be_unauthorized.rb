# frozen_string_literal: true

module APIMatchers
  module HTTPStatus
    class BeUnauthorized < Base
      protected

      def expected_status_match?
        actual_status.to_i == 401
      end

      def expectation_description
        "be unauthorized (401)"
      end
    end
  end
end
