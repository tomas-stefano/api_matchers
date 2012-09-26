module APIMatchers
  module Core
    class FindInJSON
      attr_reader :json

      def initialize(json)
        @json = json
      end

      def find(options={})
        expected_key = options.fetch(:node).to_s
        expected_value = options.fetch(:value) if options.has_key? :value
        @json.each do |key, value|
          if key == expected_key
            unless expected_value.nil?
              if expected_value.is_a? DateTime or expected_value.is_a? Date
                  expected_value = expected_value.to_s
              elsif expected_value.is_a? Time
                  expected_value = expected_value.to_datetime.to_s
              end
            end
            
            if value == expected_value or expected_value.nil?
              return value
            end
          end
          # do we have more to recurse through?
          keep_going = nil
          if value.is_a? Hash
            keep_going = value                  # hash, keep going
          elsif value.is_a? Array
            keep_going = value                  # an array, keep going
          elsif value.nil? and key.is_a? Hash
            keep_going = key                    # the array was passed in and now in the key, keep going
          end

          if keep_going
            begin
              # ignore nodes where the key doesn't match
              return FindInJSON.new(keep_going).find(node: expected_key, value: expected_value)
            rescue ::APIMatchers::Core::Exceptions::KeyNotFound
            end
          end

        end
        raise ::APIMatchers::Core::Exceptions::KeyNotFound.new( "key was not found" ) # we did not find the requested key
      end
    end
  end
end