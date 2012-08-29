module APIMatchers
  module Core
    class FindInJSON
      attr_reader :json

      def initialize(json)
        @json = json
      end

      def find(options={})
        expected_key = options.fetch(:node).to_s

        @json.each do |key, value|
          if key == expected_key
            return value
          end
          if value.is_a? Hash
            return FindInJSON.new(value).find(node: expected_key)
          end
        end
        raise ::APIMatchers::Core::Exceptions::KeyNotFound.new( "key was not found" ) # we did not find the requested key
      end
    end
  end
end