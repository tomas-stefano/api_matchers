require 'spec_helper'

RSpec.describe APIMatchers::HTTPStatusCode::BeForbidden do
  describe "should be_forbidden" do
    it "should passes if the actual is equal to 403" do
      expect(403).to be_forbidden
    end

    it "should fails if the actual is not equal to 403" do
      expect {
        expect(400).to be_forbidden
      }.to fail_with(%Q{expected that '400' to be Forbidden with the status '403'.})
    end
  end

  describe "should_not be_forbidden" do
    it "should pass if the actual is not equal to 403" do
      expect(201).not_to be_forbidden
    end

    it "should fail if the actual is equal to 403" do
      expect {
        expect(403).not_to be_forbidden
      }.to fail_with(%Q{expected that '403' to NOT be Forbidden.})
    end
  end

  describe "with change configuration" do
    before do
      APIMatchers.setup { |config| config.http_status_method = :http_status }
    end

    after do
      APIMatchers.setup { |config| config.http_status_method = nil }
    end

    it "should pass if the actual.http_status is equal to 403" do
      response = OpenStruct.new(:http_status => 403)
      expect(response).to be_forbidden
    end

    it "should fail if the actual.http_status is not equal to 403" do
      response = OpenStruct.new(:http_status => 402)
      expect {
        expect(response).to be_forbidden
      }.to fail_with(%Q{expected that '402' to be Forbidden with the status '403'.})
    end
  end
end