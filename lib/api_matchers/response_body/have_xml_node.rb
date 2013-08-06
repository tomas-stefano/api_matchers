require 'nokogiri'

module APIMatchers
  module ResponseBody
    class HaveXmlNode < Base
      def matches?(actual)
        value = false
        @actual = actual
        xml = Nokogiri::XML(response_body)
        node_set = xml.css("//#{@expected_node}")
        if node_set
          node_set.each do |node|
            if @with_value
              value = (node.text == @with_value.to_s)
            elsif @expected_including_text
              value = (node.text.to_s.include?(@expected_including_text))
            else
              value = node.text.present?
            end
            # if value is true, time to return
            return value if value
          end
        end
        # at this point, it failed to match
        return value
      end
    end
  end
end