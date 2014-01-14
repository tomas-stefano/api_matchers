require 'spec_helper'

describe APIMatchers::ResponseBody::HaveXmlNode do
  describe "actual).to have_xml_node" do
    context 'expected key and value in top level' do
      it "should pass when the expected key exist" do
        expect("<product>gateway</product>").to have_xml_node(:product)
      end

      it "should fail when the expected key does not exist" do
        expect {
          expect("<product>pabx</product>").to have_xml_node(:developers)
        }.to fail_with(%Q{expected to have node called: 'developers'. Got: '<product>pabx</product>'})
      end

      it "should pass when the expected key exist with the expected value" do
        expect("<product>payment-gateway</product>").to have_xml_node(:product).with('payment-gateway')
      end

      it "should fail when the expected key exist but the expected value don't exist" do
        expect {
          expect("<product>payment-gateway</product>").to have_xml_node(:product).with('email-marketing')
        }.to fail_with(%Q{expected to have node called: 'product' with value: 'email-marketing'. Got: '<product>payment-gateway</product>'})
      end

      it "should not parse the matcher for xml when you pass a json" do
        expect {
          expect({ :name => 'webdesk'}.to_json).to have_xml_node(:name).with('webdesk')
        }.to fail_with(%Q{expected to have node called: 'name' with value: 'webdesk'. Got: '{"name":"webdesk"}'})
      end
    end

    context 'expected key and value in more deep in the XML' do
      it "should pass when the expected key exist" do
        expect("<transaction><id>150</id></transaction>").to have_xml_node(:id)
      end

      it "should pass when the expected key and expected value exist" do
        expect("<transaction><error><code>999</code></error></transaction>").to have_xml_node(:code).with('999')
      end

      it "should fail when the expected key does not exist" do
        expect {
         expect("<transaction><error></error></transaction>").to have_xml_node(:code)
        }.to fail_with(%Q{expected to have node called: 'code'. Got: '<transaction><error></error></transaction>'})
      end

      it "should fail when the expected key exist but don't exist the expected value" do
        expect {
         expect("<transaction><error><code>999</code></error></transaction>").to have_xml_node(:code).with('001')
        }.to fail_with(%Q{expected to have node called: 'code' with value: '001'. Got: '<transaction><error><code>999</code></error></transaction>'})
      end
    end

    context "including_text" do
      it "should pass when the expected is included in the actual" do
        expect("<error><message>Transaction error: Name can't be blank</message></error>").to have_xml_node(:message).including_text("Transaction error")
      end

      it "should fail when the expected is not included in the actual" do
        expect {
          expect("<error><message>Transaction error: Name can't be blank</message></error>").to have_xml_node(:message).including_text("Fox on the run")
        }.to fail_with(%Q{expected to have node called: 'message' including text: 'Fox on the run'. Got: '<error><message>Transaction error: Name can't be blank</message></error>'})
      end
    end

    context "find matching node when multiple records" do
      it "should pass when the expected is included in the actual (1 level)" do
        expect(%{
          <messages>
            <message><id>4</id></message>
            <message><id>2</id></message>
          </messages>
        }).to have_xml_node(:id).with(2)
      end

      it "should fail when the expected is not included in the actual (1 level)" do
        expect(%{
          <messages>
            <message><id>4</id></message>
            <message><id>2</id></message>
          </messages>
        }).not_to have_xml_node(:id).with(3)
      end

      it "should pass when the expected is included in the actual (2 levels)" do
        expect(%{
          <messages>
            <message><header><id>4</id></header></message>
            <message><header><id>2</id></header></message>
          </messages>
        }).to have_xml_node(:id).with(2)
      end

      it "should fail when the expected is not included in the actual (2 levels)" do
        expect(%{
          <messages>
            <message><header><id>4</id></header></message>
            <message><header><id>2</id></header></message>
          </messages>
        }).not_to have_xml_node(:id).with(3)
      end
    end
  end

  describe "actual).not_to have_xml_node" do
    it "should pass when don't have the expected node in root level" do
      expect("<product>gateway</product>").not_to have_xml_node(:status)
    end

    it "should pass when don't have the expected node in any level" do
      expect("<transaction><id>12</id><status>paid</status></transaction>").not_to have_xml_node(:error)
    end

    it "should fail when the expected key exist" do
      expect {
       expect("<transaction><status>paid</status></transaction>").not_to have_xml_node(:status)
      }.to fail_with(%Q{expected to NOT have node called: 'status'. Got: '<transaction><status>paid</status></transaction>'})
    end

    it "should pass when have the expected key but have a different value" do
      expect("<status>paid</status>").not_to have_xml_node(:status).with('not_authorized')
    end

    it "should fail when have the expected key and have the expected value" do
      expect {
       expect("<transaction><status>paid</status></transaction>").not_to have_xml_node(:status).with('paid')
      }.to fail_with(%Q{expected to NOT have node called: 'status' with value: 'paid'. Got: '<transaction><status>paid</status></transaction>'})
    end

    context "including_text" do
      it "should pass when the expected is included in the actual" do
        expect("<error><message>Transaction error: Name can't be blank</message></error>").not_to have_xml_node(:message).including_text("Girls of Summer")
      end

      it "should fail when the expected is not included in the actual" do
        expect {
          expect("<error><message>Transaction error: Name can't be blank</message></error>").not_to have_xml_node(:message).including_text("Transaction error")
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
      expect(response).to have_xml_node(:foo).with('bar')
    end

    it "should fail if the actual.http_status is not equal to 400" do
      response = OpenStruct.new(:response_body => "<baz>bar</baz>")
      expect {
        expect(response).to have_xml_node(:bar)
      }.to fail_with(%Q{expected to have node called: 'bar'. Got: '<baz>bar</baz>'})
    end
  end
end