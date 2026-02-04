# frozen_string_literal: true

module APIMatchers
  module ErrorResponse
    class HaveError < Base
      COMMON_ERROR_KEYS = %w[error errors message messages].freeze

      def failure_message
        "expected response to have error(s). " \
          "Looked for keys: #{COMMON_ERROR_KEYS.inspect} and at path '#{errors_path}'. " \
          "Got: #{truncate_json(parsed_json)}"
      end

      def failure_message_when_negated
        "expected response NOT to have error(s), but errors were found"
      end

      def description
        "have error(s)"
      end

      protected

      def perform_match
        has_errors_at_path? || has_error_keys_at_root?
      end

      private

      def has_errors_at_path?
        errors = safe_json_at_path(errors_path)
        errors_present?(errors)
      end

      def has_error_keys_at_root?
        return false unless parsed_json.is_a?(Hash)

        COMMON_ERROR_KEYS.any? do |key|
          value = parsed_json[key] || parsed_json[key.to_sym]
          errors_present?(value)
        end
      end

      def errors_present?(value)
        case value
        when Array
          value.any?
        when Hash
          value.any?
        when String
          value.present?
        else
          false
        end
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
