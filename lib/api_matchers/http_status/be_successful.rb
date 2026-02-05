# frozen_string_literal: true

module APIMatchers
  module HTTPStatus
    class BeSuccessful < Base
      protected

      def expected_status_match?
        ::APIMatchers::Core::HTTPStatusCodes.successful?(actual_status)
      end

      def expectation_description
        "be successful (2xx)"
      end
    end
  end
end
