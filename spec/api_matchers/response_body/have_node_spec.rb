require 'spec_helper'

describe APIMatchers::ResponseBody::HaveNode do
  describe "in json" do
    before do
      APIMatchers.setup { |config| config.have_node_matcher = :json }
    end

    it "should parse the matcher for json" do
      { :product => 'chat' }.to_json.should have_node(:product).with('chat')
    end
  end

  describe "in xml" do
    before do
      APIMatchers.setup { |config| config.have_node_matcher = :xml }
    end

    it "should parse the matcher for xml" do
      "<product>chat</product>".should have_node(:product).with('chat')
    end

    after do
      APIMatchers.setup { |config| config.have_node_matcher = :json }
    end
  end
end