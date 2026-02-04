# frozen_string_literal: true

module APIMatchers
  module HTTPStatus
    class BeNoContent < Base
      protected

      def expected_status_match?
        actual_status.to_i == 204
      end

      def expectation_description
        "be no content (204)"
      end
    end
  end
end
