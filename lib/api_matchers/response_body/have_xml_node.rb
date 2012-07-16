require 'nokogiri'

module APIMatchers
  module ResponseBody
    class HaveXmlNode < Base
      def matches?(actual)
        @actual = actual
        xml = Nokogiri::XML(response_body)
        node = xml.xpath("//#{@expected_node}").text

        if @with_value
          node == @with_value.to_s
        else
          node.present?
        end
      end
    end
  end
end