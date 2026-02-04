# frozen_string_literal: true

module APIMatchers
  module HTTPStatus
    class BeForbidden < Base
      protected

      def expected_status_match?
        actual_status.to_i == 403
      end

      def expectation_description
        "be forbidden (403)"
      end
    end
  end
end
