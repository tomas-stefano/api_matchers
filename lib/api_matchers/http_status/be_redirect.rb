# frozen_string_literal: true

module APIMatchers
  module HTTPStatus
    class BeRedirect < Base
      protected

      def expected_status_match?
        ::APIMatchers::Core::HTTPStatusCodes.redirect?(actual_status)
      end

      def expectation_description
        "be redirect (3xx)"
      end
    end
  end
end
