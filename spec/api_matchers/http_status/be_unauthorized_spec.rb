require 'spec_helper'

RSpec.describe APIMatchers::HTTPStatus::BeUnauthorized do
  describe "actual.to be_unauthorized" do
    it "passes for status 401" do
      expect(401).to be_unauthorized
    end

    it "fails for status 200" do
      expect {
        expect(200).to be_unauthorized
      }.to fail_with("expected response to be unauthorized (401). Got: 200")
    end

    it "fails for status 403" do
      expect {
        expect(403).to be_unauthorized
      }.to fail_with("expected response to be unauthorized (401). Got: 403")
    end
  end

  describe "actual.not_to be_unauthorized" do
    it "passes for non-401 status" do
      expect(200).not_to be_unauthorized
    end

    it "fails for 401 status" do
      expect {
        expect(401).not_to be_unauthorized
      }.to fail_with("expected response NOT to be unauthorized (401). Got: 401")
    end
  end
end
