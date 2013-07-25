module APIMatchers
  module Core
    module Parser
      def json
        JSON.parse(response_body)
      rescue JSON::ParserError => exception
        raise ::APIMatchers::InvalidJSON.new("Invalid JSON: '#{response_body}'")
      end
    end
  end
end