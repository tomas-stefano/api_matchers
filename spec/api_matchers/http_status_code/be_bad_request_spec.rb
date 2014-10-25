require 'spec_helper'

RSpec.describe APIMatchers::HTTPStatusCode::BeBadRequest do
  describe "should be_bad_request" do
    it "should passes if the actual is equal to 400" do
      expect(400).to be_bad_request
    end

    it "should fails if the actual is not equal to 400" do
      expect {
        expect(401).to be_bad_request
      }.to fail_with(%Q{expected that '401' to be a Bad Request with the status '400'.})
    end
  end

  describe "should_not be_bad_request" do
    it "should passes if the actual is not equal to 400" do
      expect(401).not_to be_bad_request
    end

    it "should fail if the actual is equal to 400" do
      expect {
        expect(400).not_to be_bad_request
      }.to fail_with(%Q{expected that '400' to NOT be a Bad Request with the status '400'.})
    end
  end

  describe "with change configuration" do
    before do
      APIMatchers.setup { |config| config.http_status_method = :http_status }
    end

    after do
      APIMatchers.setup { |config| config.http_status_method = nil }
    end

    it "should pass if the actual.http_status is equal to 400" do
      response = OpenStruct.new(:http_status => 400)
      expect(response).to be_bad_request
    end

    it "should fail if the actual.http_status is not equal to 400" do
      response = OpenStruct.new(:http_status => 500)
      expect {
        expect(response).to be_bad_request
      }.to fail_with(%Q{expected that '500' to be a Bad Request with the status '400'.})
    end
  end
end