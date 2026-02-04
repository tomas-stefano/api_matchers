# frozen_string_literal: true

module APIMatchers
  module HTTPStatus
    class BeNotFound < Base
      protected

      def expected_status_match?
        actual_status.to_i == 404
      end

      def expectation_description
        "be not found (404)"
      end
    end
  end
end
