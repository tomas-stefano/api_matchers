require 'spec_helper'

RSpec.describe APIMatchers::HTTPStatusCode::BeUnauthorized do
  describe "should be_unauthorized" do
    it "should passes if the actual is equal to 401" do
      expect(401).to be_unauthorized
    end

    it "should fails if the actual is not equal to 401" do
      expect {
        expect(400).to be_unauthorized
      }.to fail_with(%Q{expected that '400' to be Unauthorized with the status '401'.})
    end
  end

  describe "should_not be_unauthorized" do
    it "should pass if the actual is not equal to 401" do
      expect(201).not_to be_unauthorized
    end

    it "should fail if the actual is equal to 401" do
      expect {
        expect(401).not_to be_unauthorized
      }.to fail_with(%Q{expected that '401' to NOT be Unauthorized.})
    end
  end

  describe "with change configuration" do
    before do
      APIMatchers.setup { |config| config.http_status_method = :http_status }
    end

    after do
      APIMatchers.setup { |config| config.http_status_method = nil }
    end

    it "should pass if the actual.http_status is equal to 401" do
      response = OpenStruct.new(:http_status => 401)
      expect(response).to be_unauthorized
    end

    it "should fail if the actual.http_status is not equal to 401" do
      response = OpenStruct.new(:http_status => 402)
      expect {
        expect(response).to be_unauthorized
      }.to fail_with(%Q{expected that '402' to be Unauthorized with the status '401'.})
    end
  end
end