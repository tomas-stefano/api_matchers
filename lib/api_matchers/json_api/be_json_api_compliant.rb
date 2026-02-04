# frozen_string_literal: true

module APIMatchers
  module JsonApi
    class BeJsonApiCompliant < Base
      REQUIRED_TOP_LEVEL_MEMBERS = %w[data errors meta].freeze
      VALID_TOP_LEVEL_MEMBERS = %w[data errors meta links included jsonapi].freeze
      REQUIRED_RESOURCE_MEMBERS = %w[id type].freeze

      def failure_message
        "expected response to be JSON:API compliant. Violations: #{@violations.join('; ')}. " \
          "Got: #{truncate_json(parsed_json)}"
      end

      def failure_message_when_negated
        "expected response NOT to be JSON:API compliant, but it was"
      end

      def description
        "be JSON:API compliant"
      end

      protected

      def perform_match
        @violations = []
        validate_top_level_structure
        return @violations.empty? unless parsed_json.is_a?(Hash)

        validate_data_member if has_data?
        validate_errors_member if has_errors?

        @violations.empty?
      end

      private

      def validate_top_level_structure
        unless parsed_json.is_a?(Hash)
          @violations << "top-level must be an object"
          return
        end

        # Must have at least one of: data, errors, or meta
        keys = parsed_json.keys.map(&:to_s)
        unless (keys & REQUIRED_TOP_LEVEL_MEMBERS).any?
          @violations << "must contain at least one of: data, errors, or meta"
        end

        # data and errors must not coexist
        if has_data? && has_errors?
          @violations << "data and errors must not coexist"
        end
      end

      def validate_data_member
        data = json_api_data

        case data
        when Hash
          validate_resource_object(data)
        when Array
          data.each_with_index do |resource, index|
            validate_resource_object(resource, "data[#{index}]")
          end
        when nil
          # null is valid for data
        else
          @violations << "data must be null, an object, or an array"
        end
      end

      def validate_resource_object(resource, path = "data")
        unless resource.is_a?(Hash)
          @violations << "#{path} must be an object"
          return
        end

        keys = resource.keys.map(&:to_s)

        # Must have id and type (unless it's a new resource being created)
        unless keys.include?('type')
          @violations << "#{path} must contain 'type'"
        end

        # id must be a string
        if resource.key?('id') || resource.key?(:id)
          id = resource['id'] || resource[:id]
          unless id.is_a?(String) || id.is_a?(Integer)
            @violations << "#{path}.id must be a string or integer"
          end
        end

        # type must be a string
        type = resource['type'] || resource[:type]
        if type && !type.is_a?(String)
          @violations << "#{path}.type must be a string"
        end

        # Validate attributes
        attributes = resource['attributes'] || resource[:attributes]
        if attributes && !attributes.is_a?(Hash)
          @violations << "#{path}.attributes must be an object"
        end

        # Validate relationships
        relationships = resource['relationships'] || resource[:relationships]
        if relationships
          validate_relationships(relationships, path)
        end
      end

      def validate_relationships(relationships, path)
        unless relationships.is_a?(Hash)
          @violations << "#{path}.relationships must be an object"
          return
        end

        relationships.each do |name, rel|
          rel_path = "#{path}.relationships.#{name}"
          unless rel.is_a?(Hash)
            @violations << "#{rel_path} must be an object"
            next
          end

          # Must have at least one of: links, data, or meta
          rel_keys = rel.keys.map(&:to_s)
          unless (rel_keys & %w[links data meta]).any?
            @violations << "#{rel_path} must contain links, data, or meta"
          end
        end
      end

      def validate_errors_member
        errors = json_api_errors

        unless errors.is_a?(Array)
          @violations << "errors must be an array"
          return
        end

        errors.each_with_index do |error, index|
          unless error.is_a?(Hash)
            @violations << "errors[#{index}] must be an object"
          end
        end
      end

      def has_data?
        parsed_json.key?('data') || parsed_json.key?(:data)
      end

      def has_errors?
        parsed_json.key?('errors') || parsed_json.key?(:errors)
      end
    end
  end
end
