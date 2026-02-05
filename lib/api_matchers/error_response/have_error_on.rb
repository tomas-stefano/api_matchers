# frozen_string_literal: true

module APIMatchers
  module ErrorResponse
    class HaveErrorOn < Base
      def initialize(field)
        @field = field.to_s
        @expected_message = nil
        @message_pattern = nil
      end

      def with_message(message)
        @expected_message = message
        self
      end

      def matching(pattern)
        @message_pattern = pattern
        self
      end

      def failure_message
        errors = find_errors

        if errors.nil? || errors.empty?
          "expected response to have error on '#{@field}', but no errors were found. " \
            "Got: #{truncate_json(parsed_json)}"
        elsif !field_has_error?(errors)
          "expected response to have error on '#{@field}'. " \
            "Found errors on: #{error_fields(errors).inspect}"
        elsif @expected_message
          "expected error on '#{@field}' to have message '#{@expected_message}'. " \
            "Got messages: #{field_messages(errors).inspect}"
        elsif @message_pattern
          "expected error on '#{@field}' to match #{@message_pattern.inspect}. " \
            "Got messages: #{field_messages(errors).inspect}"
        else
          "expected response to have error on '#{@field}'"
        end
      end

      def failure_message_when_negated
        if @expected_message
          "expected NOT to have error on '#{@field}' with message '#{@expected_message}', but it was found"
        elsif @message_pattern
          "expected NOT to have error on '#{@field}' matching #{@message_pattern.inspect}, but it was found"
        else
          "expected NOT to have error on '#{@field}', but it was found"
        end
      end

      def description
        desc = "have error on '#{@field}'"
        desc += " with message '#{@expected_message}'" if @expected_message
        desc += " matching #{@message_pattern.inspect}" if @message_pattern
        desc
      end

      protected

      def perform_match
        errors = find_errors
        return false if errors.nil? || errors.empty?
        return false unless field_has_error?(errors)

        if @expected_message
          message_matches?(errors, @expected_message)
        elsif @message_pattern
          message_matches_pattern?(errors, @message_pattern)
        else
          true
        end
      end

      private

      def find_errors
        # Try errors path first
        errors = safe_json_at_path(errors_path)
        return errors if errors.is_a?(Array) || errors.is_a?(Hash)

        # Try root level
        if parsed_json.is_a?(Hash)
          # Rails-style errors: { field: ["message1", "message2"] }
          return parsed_json if parsed_json.key?(@field) || parsed_json.key?(@field.to_sym)
          return parsed_json['errors'] if parsed_json['errors']
          return parsed_json[:errors] if parsed_json[:errors]
          # Check if root has any field-like structure
          return parsed_json if parsed_json.values.any? { |v| v.is_a?(Array) }
        end

        nil
      end

      def field_has_error?(errors)
        case errors
        when Array
          errors.any? { |e| error_for_field?(e) }
        when Hash
          # Rails-style: { field: ["message1", "message2"] }
          errors.key?(@field) || errors.key?(@field.to_sym) ||
            # Or hash with field key
            errors.any? { |_, v| v.is_a?(Hash) && error_for_field?(v) }
        else
          false
        end
      end

      def error_for_field?(error)
        return false unless error.is_a?(Hash)

        field_key = error_field_key
        field_value = error[field_key] || error[field_key.to_sym] ||
                      error['field'] || error[:field] ||
                      error['attribute'] || error[:attribute]

        field_value.to_s == @field
      end

      def error_fields(errors)
        case errors
        when Array
          errors.filter_map do |e|
            next unless e.is_a?(Hash)
            e[error_field_key] || e[error_field_key.to_sym] ||
              e['field'] || e[:field] ||
              e['attribute'] || e[:attribute]
          end.map(&:to_s).uniq
        when Hash
          errors.keys.map(&:to_s)
        else
          []
        end
      end

      def field_messages(errors)
        case errors
        when Array
          errors.filter_map do |e|
            next unless e.is_a?(Hash) && error_for_field?(e)
            e[error_message_key] || e[error_message_key.to_sym] ||
              e['message'] || e[:message]
          end
        when Hash
          # Rails-style: { field: ["message1", "message2"] }
          messages = errors[@field] || errors[@field.to_sym]
          messages.is_a?(Array) ? messages : [messages].compact
        else
          []
        end
      end

      def message_matches?(errors, expected)
        field_messages(errors).any? { |m| m.to_s == expected.to_s }
      end

      def message_matches_pattern?(errors, pattern)
        field_messages(errors).any? { |m| m.to_s.match?(pattern) }
      end

      def safe_json_at_path(path)
        json_at_path(path)
      rescue ::APIMatchers::Core::Exceptions::PathNotFound
        nil
      end

      def truncate_json(json)
        str = json.to_json
        str.length > 200 ? "#{str[0..200]}..." : str
      end
    end
  end
end
