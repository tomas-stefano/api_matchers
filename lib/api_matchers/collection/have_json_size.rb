# frozen_string_literal: true

module APIMatchers
  module Collection
    class HaveJsonSize < Base
      def initialize(expected_size)
        @expected_size = expected_size
        @path = nil
      end

      def at_path(path)
        @path = path
        self
      end

      def failure_message
        if @collection.nil?
          "expected JSON at '#{@path || 'root'}' to be a collection with size #{@expected_size}, " \
            "but path was not found or value was not a collection"
        else
          "expected JSON collection at '#{@path || 'root'}' to have size #{@expected_size}. " \
            "Got size: #{@collection.size}"
        end
      end

      def failure_message_when_negated
        "expected JSON collection at '#{@path || 'root'}' NOT to have size #{@expected_size}, " \
          "but it did"
      end

      def description
        desc = "have JSON size #{@expected_size}"
        desc += " at path '#{@path}'" if @path
        desc
      end

      protected

      def perform_match
        value = json_at_path(@path)
        unless value.is_a?(Array) || value.is_a?(Hash)
          @collection = nil
          return false
        end

        @collection = value
        @collection.size == @expected_size
      rescue ::APIMatchers::Core::Exceptions::PathNotFound
        @collection = nil
        false
      end
    end
  end
end
