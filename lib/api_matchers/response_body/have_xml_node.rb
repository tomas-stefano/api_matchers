# frozen_string_literal: true

require 'nokogiri'

module APIMatchers
  module ResponseBody
    class HaveXmlNode < Base
      def matches?(actual)
        @actual = actual
        xml = Nokogiri::XML(response_body)

        node_set = xml.xpath("//#{@expected_node}")
        return false unless node_set

        node_set.each do |node|
          if @with_value
            return true if node.text == @with_value.to_s
          elsif @expected_including_text
            return true if node.text.to_s.include?(@expected_including_text)
          else
            return true if node.text.present?
          end
        end

        false
      end
    end
  end
end