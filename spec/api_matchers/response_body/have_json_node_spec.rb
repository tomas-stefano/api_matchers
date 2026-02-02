require 'spec_helper'

RSpec.describe APIMatchers::ResponseBody::HaveJsonNode do
  describe "actual).to have_json_node" do
    context 'expected key and value in top level' do
      it "pass when the expected key exist" do
        expect({ :product => 'gateway' }.to_json).to have_json_node(:product)
      end

      it "fail when the expected key does not exist" do
        expect {
          expect({ :product => 'pabx' }.to_json).to have_json_node(:developers)
        }.to fail_with(%Q{expected to have node called: 'developers'. Got: '{"product":"pabx"}'})
      end

      it "pass when the expected key exist with the expected value" do
        expect({ :product => 'payment-gateway' }.to_json).to have_json_node(:product).with('payment-gateway')
      end

      it "pass when the expected key exist with the expected value (as integer)" do
        expect({ :number => 1 }.to_json).to have_json_node(:number).with(1)
      end

      it "pass when the expected key exist with the expected value (as boolean, true)" do
        expect({ :number => true }.to_json).to have_json_node(:number).with(true)
      end

      it "pass when the expected key exist with the expected value (as boolean, false)" do
        expect({ :number => false }.to_json).to have_json_node(:number).with(false)
      end

      it "pass when the expected key exist but the expected value is wrong (as boolean, true)" do
        expect({ :number => true }.to_json).not_to have_json_node(:number).with(false)
      end

      it "pass when the expected key exist but the expected value is wrong (as boolean, false)" do
        expect({ :number => false }.to_json).not_to have_json_node(:number).with(true)
      end

      it "pass when the expected key exists with the expected value (as DateTime)" do
        now = DateTime.now.to_s
        expect({ :date => now }.to_json).to have_json_node(:date).with(now)
      end

      it "pass when the expected key exists with the expected value (as Date)" do
        now = Date.today
        expect({ :date => now }.to_json).to have_json_node(:date).with(now)
      end

      it "pass when the expected key exists with the expected value (as Time)" do
        now = Time.now.to_s
        expect({ :time => now }.to_json).to have_json_node(:time).with(now)
      end

      it "fail when the expected key exist but the expected value don't exist" do
        expect {
          expect({ :product => 'payment-gateway' }.to_json).to have_json_node(:product).with('email-marketing')
        }.to fail_with(%Q{expected to have node called: 'product' with value: 'email-marketing'. Got: '{"product":"payment-gateway"}'})
      end

      it "not parse the matcher for json when you pass a xml" do
        expect {
          expect("<product><name>webdesk</name></product>").to have_json_node(:name).with('webdesk')
        }.to raise_error(APIMatchers::InvalidJSON, "Invalid JSON: '<product><name>webdesk</name></product>'")
      end
    end

    context 'expected key and nil value' do
      it "pass when the expected key exists" do
        expect({ :product => nil }.to_json).to have_json_node(:product)
      end

      it "pass when the expected key exists and the expected value is nil" do
        expect({ :product => nil }.to_json).to have_json_node(:product).with( nil )
      end

      it "fail when the expected key exist but the expected value don't exist" do
        expect {
          expect({ :product => nil }.to_json).to have_json_node(:product).with('email-marketing')
        }.to fail_with(%Q{expected to have node called: 'product' with value: 'email-marketing'. Got: '{"product":null}'})
      end
    end

    context 'expected key and value in more deep in the JSON' do
      context '.to_json used' do
        it "pass when the expected key exist" do
          expect({ :transaction => { :id => 150 } }.to_json).to have_json_node(:id)
        end

        it "pass when the expected key and expected value exist" do
          expect({ :transaction => { :error => { :code => '999' } } }.to_json).to have_json_node(:code).with('999')
        end

        it "pass when the expected key and expected value exist in very deep" do
          expect({ :first=>"A", :second=>nil, :third=>{ :stuff => { :first_stuff=>{ :color=>"green", :size=>"small", :shape=>"circle", :uid=>"first_stuff"}, :second_stuff=>{ :color=>"blue", :size=>"large", :shape=>"square", :uid=>"second_stuff"}}, :junk=>[{"name"=>"junk_one", :uid=>"junk_one", :stuff_uid=>"first_stuff"}, { :name=>"junk_two", :uid=>"junk_two", :stuff_uid=>"second_stuff"}]}}.to_json).to have_json_node( :junk )
        end

        it "pass when the expected key and expected value exist in very deep" do
          expect({ :first=>"A", :second=>nil, :third=>{ :stuff => { :first_stuff=>{ :color=>"green", :size=>"small", :shape=>"circle", :uid=>"first_stuff"}, :second_stuff=>{ :color=>"blue", :size=>"large", :shape=>"square", :uid=>"second_stuff"}}, :junk=>[{"name"=>"junk_one", :uid=>"junk_one", :stuff_uid=>"first_stuff"}, { :name=>"junk_two", :uid=>"junk_two", :stuff_uid=>"second_stuff"}]}}.to_json).to have_json_node( :name ).with( "junk_two" )
        end

        it "fail when the expected key does not exist" do
          expect {
            expect({ :transaction => { :id => 150, :error => {} } }.to_json).to have_json_node(:code)
          }.to fail_with(%Q{expected to have node called: 'code'. Got: '{"transaction":{"id":150,"error":{}}}'})
        end

        it "fail when the expected key exist but don't exist the expected value" do
          expect {
            expect({ :transaction => { :id => 150, :error => { :code => '999' } } }.to_json).to have_json_node(:code).with('001')
          }.to fail_with(%Q{expected to have node called: 'code' with value: '001'. Got: '{"transaction":{"id":150,"error":{"code":"999"}}}'})
        end
      end
      context 'json string used' do
        it "pass when the expected key exist" do
          expect('{ "transaction": {"id": 150 } }').to have_json_node(:id)
        end

        it "pass when the expected key and expected value exist" do
          expect('{ "transaction": {"error": { "code": "999" } } }').to have_json_node(:code).with('999')
        end

        it "pass when the expected key exist with the expected value (as integer)" do
          expect('{"number":1 }').to have_json_node(:number).with(1)
        end

        it "pass when the expected key exist with the expected value (as boolean)" do
          expect('{"boolean":true}').to have_json_node(:boolean).with(true)
        end

        it "pass when the expected key exists with the expected value (as DateTime)" do
          now = DateTime.parse( "2012-09-18T15:42:12-07:00" )
          expect('{"date": "2012-09-18T15:42:12-07:00"}').to have_json_node(:date).with(now)
        end

        it "pass when the expected key exists with the expected value (as Date)" do
          now = Date.parse( "2012-09-18" )
          expect('{"date": "2012-09-18"}').to have_json_node(:date).with(now)
        end

        it "pass when the expected key exists with the expected value (as Time)" do
          now = Time.parse("2012-09-18T15:42:12Z")
          expect('{"time": "2012-09-18T15:42:12+00:00"}').to have_json_node(:time).with(now)
        end

        it "pass when the expected key exist with the expected value (as boolean) in a multi node" do
          expect('{"uid":"123456","boolean":true}').to have_json_node(:boolean).with(true)
        end

        it "pass when the expected key and expected value exist in very deep" do
          expect('{"first":"A","second":null,"third":{"stuff":{"first_stuff":{"color":"green","size":"small","shape":"circle","uid":"first_stuff"},"second_stuff":{"color":"blue","size":"large","shape":"square","uid":"second_stuff"}},"junk":[{"name":"junk_one","uid":"junk_one","stuff_uid":"first_stuff"},{"name":"junk_two","uid":"junk_two","stuff_uid":"second_stuff"}]}}').to have_json_node( :junk )
        end

        it "pass when the expected key and expected value exist in very deep" do
          expect('{"first":"A","second":null,"third":{"stuff":{"first_stuff":{"color":"green","size":"small","shape":"circle","uid":"first_stuff"},"second_stuff":{"color":"blue","size":"large","shape":"square","uid":"second_stuff"}},"junk":[{"name":"junk_one","uid":"junk_one","stuff_uid":"first_stuff"},{"name":"junk_two","uid":"junk_two","stuff_uid":"second_stuff"}]}}').to have_json_node( :name ).with( "junk_two" )
        end

        it "pass when the expected key and including text exist" do
          expect('{"Key":"A=123456-abcdef-09876-ghijkl; path=/; expires=Sun, 05-Sep-2032 05:50:39 GMT\nB=ABCDEF123456; path=/; expires=Sun, 05-Sep-2032 05:50:39 GMT", "Content-Type":"application/json; charset=utf-8"}').to have_json_node( "Key" ).including_text( "123456-abcdef-09876-ghijkl" )
        end

        it "fail when the expected key does not exist" do
          expect {
            expect('{"transaction":{"id":150,"error":{}}}').to have_json_node(:code)
          }.to fail_with(%Q{expected to have node called: 'code'. Got: '{"transaction":{"id":150,"error":{}}}'})
        end

        it "fail when the expected key exist but don't exist the expected value" do
          expect {
            expect('{"transaction":{"id":150,"error":{"code":"999"}}}').to have_json_node(:code).with('001')
          }.to fail_with(%Q{expected to have node called: 'code' with value: '001'. Got: '{"transaction":{"id":150,"error":{"code":"999"}}}'})
        end
      end
    end

    context "including_text" do
      let(:json) do
        { :transaction => { :error => { :message => "Transaction error: Name can't be blank" } } }.to_json
      end

      it "pass when the expected is included in the actual" do
        expect({ :transaction => { :error => { :message => "Transaction error: Name can't be blank" } } }.to_json).to have_json_node(:message).including_text("Transaction error")
      end

      it "fail when the expected is not included in the actual" do
        expect {
          expect(json).to have_json_node(:message).including_text("Fox on the run")
        }.to fail_with(%Q{expected to have node called: 'message' including text: 'Fox on the run'. Got: '{"transaction":{"error":{"message":"Transaction error: Name can't be blank"}}}'})
      end
    end
  end

  describe "actual).not_to have_json_node" do
    it "pass when don't have the expected node in root level" do
      expect({ :product => 'gateway' }.to_json).not_to have_json_node(:status)
    end

    it "pass when don't have the expected node in any level" do
      expect({ :transaction => { :id => 12, :status => 'paid' } }.to_json).not_to have_json_node(:error)
    end

    it "fail when the expected key exist" do
      expect {
        expect({ :status => 'paid' }.to_json).not_to have_json_node(:status)
      }.to fail_with(%Q{expected to NOT have node called: 'status'. Got: '{"status":"paid"}'})
    end

    it "pass when have the expected key but have a different value" do
      expect({ :status => 'paid' }.to_json).not_to have_json_node(:status).with('not_authorized')
    end

    it "fail when have the expected key and have the expected value" do
      expect {
        expect({ :status => 'paid' }.to_json).not_to have_json_node(:status).with('paid')
      }.to fail_with(%Q{expected to NOT have node called: 'status' with value: 'paid'. Got: '{"status":"paid"}'})
    end

    context "including_text" do
      it "pass when the expected is NOT included in the actual" do
        expect({ :transaction => { :error => { :message => "Transaction error: Name can't be blank" } } }.to_json).not_to have_json_node(:message).including_text("Love gun")
      end

      it "fail when the expected is included in the actual" do
        expect {
          expect({ :transaction => { :error => { :message => "Transaction error: Name can't be blank" } } }.to_json).not_to have_json_node(:message).including_text("Transaction error")
        }.to fail_with(%Q{expected to NOT have node called: 'message' including text: 'Transaction error'. Got: '{"transaction":{"error":{"message":"Transaction error: Name can't be blank"}}}'})
      end
    end
  end

  describe "some assumptions" do
    it "pass when have the json node name" do
      expect('{ "transaction": { "id": 54, "status": "paid" } }').to have_json_node(:transaction)
    end

    it "pass when have json node with integer value" do
      expect('{ "transaction": { "id": 54, "status": "paid" } }').to have_json_node(:id).with(54)
    end

    it "should have json node including text" do
      expect('{"error": "Transaction error: Name cant be blank"}').to have_json_node(:error).including_text("Transaction error")
    end

    it "pass have json node with boolean value" do
      expect('{"creditcard": true}').to have_json_node(:creditcard).with(true)
    end

    it "pass have json node with string" do
      expect('{ "error": "not_authorized", "transaction": { "id": "55" } }').to have_node(:error).with('not_authorized')
    end

    it "pass have json node with integer" do
      expect('{"parcels": 1 }').to have_node(:parcels).with(1)
    end
  end

  describe "with change configuration" do
    before do
      APIMatchers.setup { |config| config.response_body_method = :response_body }
    end

    after do
      APIMatchers.setup { |config| config.response_body_method = nil }
    end

    it "pass if the actual.http_status is equal to 400" do
      response = OpenStruct.new(:response_body => { :foo => :bar }.to_json)
      expect(response).to have_json_node(:foo).with('bar')
    end

    it "fail if the actual.http_status is not equal to 400" do
      response = OpenStruct.new(:response_body => { :baz => :foo}.to_json)
      expect {
        expect(response).to have_json_node(:bar)
      }.to fail_with(%Q{expected to have node called: 'bar'. Got: '{"baz":"foo"}'})
    end
  end

  describe "including" do
    it "passes when array includes an element matching the hash" do
      json = '{"users": [{"name": "Alice", "age": 30}, {"name": "Bob", "age": 25}]}'
      expect(json).to have_json_node(:users).including(name: "Alice")
    end

    it "passes when array includes an element matching multiple attributes" do
      json = '{"users": [{"name": "Alice", "age": 30}, {"name": "Bob", "age": 25}]}'
      expect(json).to have_json_node(:users).including(name: "Alice", age: 30)
    end

    it "fails when array does not include matching element" do
      json = '{"users": [{"name": "Alice"}, {"name": "Bob"}]}'
      expect {
        expect(json).to have_json_node(:users).including(name: "Charlie")
      }.to fail_with(/expected to have node called: 'users'/)
    end

    it "fails when node is not an array" do
      json = '{"user": {"name": "Alice"}}'
      expect {
        expect(json).to have_json_node(:user).including(name: "Alice")
      }.to fail_with(/expected to have node called: 'user'/)
    end

    it "passes when array includes a simple value" do
      json = '{"tags": ["ruby", "rails", "api"]}'
      expect(json).to have_json_node(:tags).including("ruby")
    end
  end

  describe "including_all" do
    it "passes when array includes all specified elements" do
      json = '{"items": [{"id": 1}, {"id": 2}, {"id": 3}]}'
      expect(json).to have_json_node(:items).including_all([{id: 1}, {id: 2}])
    end

    it "fails when array is missing some elements" do
      json = '{"items": [{"id": 1}, {"id": 3}]}'
      expect {
        expect(json).to have_json_node(:items).including_all([{id: 1}, {id: 2}])
      }.to fail_with(/expected to have node called: 'items'/)
    end

    it "passes when array includes all simple values" do
      json = '{"numbers": [1, 2, 3, 4, 5]}'
      expect(json).to have_json_node(:numbers).including_all([1, 3, 5])
    end

    it "fails when node is not an array" do
      json = '{"item": {"id": 1}}'
      expect {
        expect(json).to have_json_node(:item).including_all([{id: 1}])
      }.to fail_with(/expected to have node called: 'item'/)
    end
  end
end
