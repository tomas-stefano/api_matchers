# frozen_string_literal: true

module APIMatchers
  module Collection
    class BeSortedBy < Base
      def initialize(field)
        @field = field.to_s
        @path = nil
        @direction = :ascending
      end

      def at_path(path)
        @path = path
        self
      end

      def ascending
        @direction = :ascending
        self
      end

      def descending
        @direction = :descending
        self
      end

      def failure_message
        if @collection.nil?
          "expected JSON at '#{@path || 'root'}' to be an array sorted by '#{@field}', " \
            "but path was not found or value was not an array"
        else
          "expected JSON array at '#{@path || 'root'}' to be sorted by '#{@field}' #{@direction}. " \
            "Got values: #{extract_values.inspect}"
        end
      end

      def failure_message_when_negated
        "expected JSON array at '#{@path || 'root'}' NOT to be sorted by '#{@field}' #{@direction}, " \
          "but it was"
      end

      def description
        desc = "be sorted by '#{@field}' #{@direction}"
        desc += " at path '#{@path}'" if @path
        desc
      end

      protected

      def perform_match
        value = json_at_path(@path)
        unless value.is_a?(Array)
          @collection = nil
          return false
        end

        @collection = value
        return true if @collection.empty? || @collection.size == 1

        sorted?
      rescue ::APIMatchers::Core::Exceptions::PathNotFound
        @collection = nil
        false
      end

      private

      def sorted?
        values = extract_values
        sorted_values = @direction == :ascending ? values.sort : values.sort.reverse

        values == sorted_values
      end

      def extract_values
        @collection.map do |item|
          value = item.is_a?(Hash) ? (item[@field] || item[@field.to_sym]) : item
          normalize_for_comparison(value)
        end
      end

      def normalize_for_comparison(value)
        case value
        when String
          # Try to parse as date/time for proper comparison
          begin
            Time.parse(value)
          rescue ArgumentError, TypeError
            value
          end
        else
          value
        end
      end
    end
  end
end
