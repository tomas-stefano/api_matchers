require 'spec_helper'

RSpec.describe APIMatchers::HTTPStatus::BeServerError do
  describe "actual.to be_server_error" do
    it "passes for status 500" do
      expect(500).to be_server_error
    end

    it "passes for status 501" do
      expect(501).to be_server_error
    end

    it "passes for status 502" do
      expect(502).to be_server_error
    end

    it "passes for status 503" do
      expect(503).to be_server_error
    end

    it "passes for status 599" do
      expect(599).to be_server_error
    end

    it "fails for status 200" do
      expect {
        expect(200).to be_server_error
      }.to fail_with("expected response to be server error (5xx). Got: 200")
    end

    it "fails for status 404" do
      expect {
        expect(404).to be_server_error
      }.to fail_with("expected response to be server error (5xx). Got: 404")
    end
  end

  describe "actual.not_to be_server_error" do
    it "passes for non-5xx status" do
      expect(200).not_to be_server_error
    end

    it "fails for 5xx status" do
      expect {
        expect(500).not_to be_server_error
      }.to fail_with("expected response NOT to be server error (5xx). Got: 500")
    end
  end
end
