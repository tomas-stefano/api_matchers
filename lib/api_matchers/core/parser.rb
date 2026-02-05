# frozen_string_literal: true

module APIMatchers
  module Core
    module Parser
      def json
        JSON.parse(response_body)
      rescue JSON::ParserError
        raise ::APIMatchers::InvalidJSON, "Invalid JSON: '#{response_body}'"
      end
    end
  end
end