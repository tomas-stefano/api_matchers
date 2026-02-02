# frozen_string_literal: true

module APIMatchers
  module Core
    class ValueNormalizer
      def self.normalize(value)
        new(value).normalize
      end

      def initialize(value)
        @value = value
      end

      def normalize
        case @value
        when DateTime, Date
          @value.to_s
        when Time
          @value.to_datetime.to_s
        else
          @value
        end
      end
    end
  end
end
