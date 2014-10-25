require 'spec_helper'

RSpec.describe APIMatchers::HTTPStatusCode::BeOk do
  describe "should be_ok" do
    it "should passes if the actual is equal to 200" do
      expect(200).to be_ok
    end

    it "should fails if the actual is not equal to 200" do
      expect {
        expect(201).to be_ok
      }.to fail_with(%Q{expected that '201' to be ok with the status '200'.})
    end
  end

  describe "should_not be_ok_request" do
    it "should passes if the actual is not equal to 200" do
      expect(201).not_to be_ok
    end

    it "should fail if the actual is equal to 200" do
      expect {
        expect(200).not_to be_ok
      }.to fail_with(%Q{expected that '200' to NOT be ok with the status '200'.})
    end
  end

  describe "with change configuration" do
    before do
      APIMatchers.setup { |config| config.http_status_method = :http_status }
    end

    after do
      APIMatchers.setup { |config| config.http_status_method = nil }
    end

    it "should pass if the actual.http_status is equal to 200" do
      response = OpenStruct.new(:http_status => 200)
      expect(response).to be_ok
    end

    it "should fail if the actual.http_status is not equal to 200" do
      response = OpenStruct.new(:http_status => 500)
      expect {
        expect(response).to be_ok
      }.to fail_with(%Q{expected that '500' to be ok with the status '200'.})
    end
  end
end