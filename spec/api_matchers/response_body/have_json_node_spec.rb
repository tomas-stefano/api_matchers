require 'spec_helper'

describe APIMatchers::ResponseBody::HaveJsonNode do
  describe "actual.should have_json_node" do
    context 'expected key and value in top level' do
      it "should pass when the expected key exist" do
        { :product => 'gateway' }.to_json.should have_json_node(:product)
      end

      it "should fail when the expected key does not exist" do
        expect {
         { :product => 'pabx' }.to_json.should have_json_node(:developers)
        }.to fail_with(%Q{expected to have node called: 'developers'. Got: '{"product":"pabx"}'})
      end

      it "should pass when the expected key exist with the expected value" do
        { :product => 'payment-gateway' }.to_json.should have_json_node(:product).with('payment-gateway')
      end

      it "should fail when the expected key exist but the expected value don't exist" do
        expect {
         { :product => 'payment-gateway' }.to_json.should have_json_node(:product).with('email-marketing')
        }.to fail_with(%Q{expected to have node called: 'product' with value: 'email-marketing'. Got: '{"product":"payment-gateway"}'})
      end

      it "should not parse the matcher for json when you pass a xml" do
        expect {
          "<product><name>webdesk</name></product>".should have_json_node(:name).with('webdesk')
        }.to fail_with(%Q{expected to have node called: 'name' with value: 'webdesk'. Got: '<product><name>webdesk</name></product>'})
      end
    end

    context 'expected key and nil value' do
      it "should pass when the expected key exists" do
        { :product => nil }.to_json.should have_json_node(:product)
      end

      it "should pass when the expected key exists and the expected value is nil" do
        { :product => nil }.to_json.should have_json_node(:product).with( nil )
      end

      it "should fail when the expected key exist but the expected value don't exist" do
        expect {
         { :product => nil }.to_json.should have_json_node(:product).with('email-marketing')
        }.to fail_with(%Q{expected to have node called: 'product' with value: 'email-marketing'. Got: '{"product":null}'})
      end
    end

    context 'expected key and value in more deep in the JSON' do
      it "should pass when the expected key exist" do
        { :transaction => { :id => 150 } }.to_json.should have_json_node(:id)
      end

      it "should pass when the expected key and expected value exist" do
        { :transaction => { :error => { :code => '999' } } }.to_json.should have_json_node(:code).with('999')
      end

      it "should fail when the expected key does not exist" do
        expect {
         { :transaction => { :id => 150, :error => {} } }.to_json.should have_json_node(:code)
        }.to fail_with(%Q{expected to have node called: 'code'. Got: '{"transaction":{"id":150,"error":{}}}'})
      end

      it "should fail when the expected key exist but don't exist the expected value" do
        expect {
         { :transaction => { :id => 150, :error => { :code => '999' } } }.to_json.should have_json_node(:code).with('001')
        }.to fail_with(%Q{expected to have node called: 'code' with value: '001'. Got: '{"transaction":{"id":150,"error":{"code":"999"}}}'})
      end
    end

    context "including_text" do
      it "should pass when the expected is included in the actual" do
        { :transaction => { :error => { :message => "Transaction error: Name can't be blank" } } }.to_json.should have_json_node(:message).including_text("Transaction error")
      end

      it "should fail when the expected is not included in the actual" do
        expect {
          { :transaction => { :error => { :message => "Transaction error: Name can't be blank" } } }.to_json.should have_json_node(:message).including_text("Fox on the run")
        }.to fail_with(%Q{expected to have node called: 'message' including text: 'Fox on the run'. Got: '{"transaction":{"error":{"message":"Transaction error: Name can't be blank"}}}'})
      end
    end
  end

  describe "actual.should_not have_json_node" do
    it "should pass when don't have the expected node in root level" do
      { :product => 'gateway' }.to_json.should_not have_json_node(:status)
    end

    it "should pass when don't have the expected node in any level" do
      { :transaction => { :id => 12, :status => 'paid' } }.to_json.should_not have_json_node(:error)
    end

    it "should fail when the expected key exist" do
      expect {
       { :status => 'paid' }.to_json.should_not have_json_node(:status)
      }.to fail_with(%Q{expected to NOT have node called: 'status'. Got: '{"status":"paid"}'})
    end

    it "should pass when have the expected key but have a different value" do
      { :status => 'paid' }.to_json.should_not have_json_node(:status).with('not_authorized')
    end

    it "should fail when have the expected key and have the expected value" do
      expect {
       { :status => 'paid' }.to_json.should_not have_json_node(:status).with('paid')
      }.to fail_with(%Q{expected to NOT have node called: 'status' with value: 'paid'. Got: '{"status":"paid"}'})
    end

    context "including_text" do
      it "should pass when the expected is NOT included in the actual" do
        { :transaction => { :error => { :message => "Transaction error: Name can't be blank" } } }.to_json.should_not have_json_node(:message).including_text("Love gun")
      end

      it "should fail when the expected is included in the actual" do
        expect {
          { :transaction => { :error => { :message => "Transaction error: Name can't be blank" } } }.to_json.should_not have_json_node(:message).including_text("Transaction error")
        }.to fail_with(%Q{expected to NOT have node called: 'message' including text: 'Transaction error'. Got: '{"transaction":{"error":{"message":"Transaction error: Name can't be blank"}}}'})
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
      response = OpenStruct.new(:response_body => { :foo => :bar }.to_json)
      response.should have_json_node(:foo).with('bar')
    end

    it "should fail if the actual.http_status is not equal to 400" do
      response = OpenStruct.new(:response_body => { :baz => :foo}.to_json)
      expect { response.should have_json_node(:bar) }.to fail_with(%Q{expected to have node called: 'bar'. Got: '{"baz":"foo"}'})
    end
  end
end