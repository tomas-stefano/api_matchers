require 'spec_helper'

RSpec.describe APIMatchers::HTTPStatus::BeClientError do
  describe "actual.to be_client_error" do
    it "passes for status 400" do
      expect(400).to be_client_error
    end

    it "passes for status 401" do
      expect(401).to be_client_error
    end

    it "passes for status 403" do
      expect(403).to be_client_error
    end

    it "passes for status 404" do
      expect(404).to be_client_error
    end

    it "passes for status 422" do
      expect(422).to be_client_error
    end

    it "passes for status 499" do
      expect(499).to be_client_error
    end

    it "fails for status 200" do
      expect {
        expect(200).to be_client_error
      }.to fail_with("expected response to be client error (4xx). Got: 200")
    end

    it "fails for status 500" do
      expect {
        expect(500).to be_client_error
      }.to fail_with("expected response to be client error (4xx). Got: 500")
    end
  end

  describe "actual.not_to be_client_error" do
    it "passes for non-4xx status" do
      expect(200).not_to be_client_error
    end

    it "fails for 4xx status" do
      expect {
        expect(404).not_to be_client_error
      }.to fail_with("expected response NOT to be client error (4xx). Got: 404")
    end
  end
end
