require 'spec_helper'

describe APIMatchers::ResponseBody::HaveXmlNode do
  describe "actual.should have_xml_node" do
    context 'expected key and value in top level' do
      it "should pass when the expected key exist" do
        "<product>gateway</product>".should have_xml_node(:product)
      end

      it "should fail when the expected key does not exist" do
        expect {
          "<product>pabx</product>".should have_xml_node(:developers)
        }.to fail_with(%Q{expected to have node called: 'developers'. Got: '<product>pabx</product>'})
      end

      it "should pass when the expected key exist with the expected value" do
        "<product>payment-gateway</product>".should have_xml_node(:product).with('payment-gateway')
      end

      it "should fail when the expected key exist but the expected value don't exist" do
        expect {
          "<product>payment-gateway</product>".should have_xml_node(:product).with('email-marketing')
        }.to fail_with(%Q{expected to have node called: 'product' with value: 'email-marketing'. Got: '<product>payment-gateway</product>'})
      end

      it "should not parse the matcher for xml when you pass a json" do
        expect {
          { :name => 'webdesk'}.to_json.should have_xml_node(:name).with('webdesk')
        }.to fail_with(%Q{expected to have node called: 'name' with value: 'webdesk'. Got: '{"name":"webdesk"}'})
      end
    end

    context 'expected key and value in more deep in the JSON' do
      it "should pass when the expected key exist" do
        "<transaction><id>150</id></transaction>".should have_xml_node(:id)
      end

      it "should pass when the expected key and expected value exist" do
        "<transaction><error><code>999</code></error></transaction>".should have_xml_node(:code).with('999')
      end

      it "should fail when the expected key does not exist" do
        expect {
         "<transaction><error></error></transaction>".should have_xml_node(:code)
        }.to fail_with(%Q{expected to have node called: 'code'. Got: '<transaction><error></error></transaction>'})
      end

      it "should fail when the expected key exist but don't exist the expected value" do
        expect {
         "<transaction><error><code>999</code></error></transaction>".should have_xml_node(:code).with('001')
        }.to fail_with(%Q{expected to have node called: 'code' with value: '001'. Got: '<transaction><error><code>999</code></error></transaction>'})
      end
    end

    context "including_text" do
      it "should pass when the expected is included in the actual" do
        "<error><message>Transaction error: Name can't be blank</message></error>".should have_xml_node(:message).including_text("Transaction error")
      end

      it "should fail when the expected is not included in the actual" do
        expect {
          "<error><message>Transaction error: Name can't be blank</message></error>".should have_xml_node(:message).including_text("Fox on the run")
        }.to fail_with(%Q{expected to have node called: 'message' including text: 'Fox on the run'. Got: '<error><message>Transaction error: Name can't be blank</message></error>'})
      end
    end
  end

  describe "actual.should_not have_xml_node" do
    it "should pass when don't have the expected node in root level" do
      "<product>gateway</product>".should_not have_xml_node(:status)
    end

    it "should pass when don't have the expected node in any level" do
      "<transaction><id>12</id><status>paid</status></transaction>".should_not have_xml_node(:error)
    end

    it "should fail when the expected key exist" do
      expect {
       "<transaction><status>paid</status></transaction>".should_not have_xml_node(:status)
      }.to fail_with(%Q{expected to NOT have node called: 'status'. Got: '<transaction><status>paid</status></transaction>'})
    end

    it "should pass when have the expected key but have a different value" do
      "<status>paid</status>".should_not have_xml_node(:status).with('not_authorized')
    end

    it "should fail when have the expected key and have the expected value" do
      expect {
       "<transaction><status>paid</status></transaction>".should_not have_xml_node(:status).with('paid')
      }.to fail_with(%Q{expected to NOT have node called: 'status' with value: 'paid'. Got: '<transaction><status>paid</status></transaction>'})
    end

    context "including_text" do
      it "should pass when the expected is included in the actual" do
        "<error><message>Transaction error: Name can't be blank</message></error>".should_not have_xml_node(:message).including_text("Girls of Summer")
      end

      it "should fail when the expected is not included in the actual" do
        expect {
          "<error><message>Transaction error: Name can't be blank</message></error>".should_not have_xml_node(:message).including_text("Transaction error")
        }.to fail_with(%Q{expected to NOT have node called: 'message' including text: 'Transaction error'. Got: '<error><message>Transaction error: Name can't be blank</message></error>'})
      end
    end
  end


  describe "with change configuration" do
    before do
      APIMatchers.setup { |config| config.response_body_method = :response_body }
    end

    after do
      APIMatchers.setup { |config| config.response_body_method = nil }
    end

    it "should pass if the actual.http_status is equal to 400" do
      response = OpenStruct.new(:response_body => "<foo>bar</foo>")
      response.should have_xml_node(:foo).with('bar')
    end

    it "should fail if the actual.http_status is not equal to 400" do
      response = OpenStruct.new(:response_body => "<baz>bar</baz>")
      expect { response.should have_xml_node(:bar) }.to fail_with(%Q{expected to have node called: 'bar'. Got: '<baz>bar</baz>'})
    end
  end
end