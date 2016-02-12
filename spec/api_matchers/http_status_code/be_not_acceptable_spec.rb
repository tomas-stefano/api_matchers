require 'spec_helper'

RSpec.describe APIMatchers::HTTPStatusCode::BeNotAcceptable do
  describe "should be_not_acceptable" do
    it "should passes if the actual is equal to 406" do
      expect(406).to be_not_acceptable
    end

    it "should fails if the actual is not equal to 406" do
      expect {
        expect(400).to be_not_acceptable
      }.to fail_with(%Q{expected that '400' to be Not Acceptable with the status '406'.})
    end
  end

  describe "should_not be_unauthorized" do
    it "should pass if the actual is not equal to 406" do
      expect(201).not_to be_not_acceptable
    end

    it "should fail if the actual is equal to 406" do
      expect {
        expect(406).not_to be_not_acceptable
      }.to fail_with(%Q{expected that '406' to NOT be Not Acceptable.})
    end
  end

  describe "with change configuration" do
    before do
      APIMatchers.setup { |config| config.http_status_method = :http_status }
    end

    after do
      APIMatchers.setup { |config| config.http_status_method = nil }
    end

    it "should pass if the actual.http_status is equal to 406" do
      response = OpenStruct.new(:http_status => 406)
      expect(response).to be_not_acceptable
    end

    it "should fail if the actual.http_status is not equal to 406" do
      response = OpenStruct.new(:http_status => 402)
      expect {
        expect(response).to be_not_acceptable
      }.to fail_with(%Q{expected that '402' to be Not Acceptable with the status '406'.})
    end
  end
end
