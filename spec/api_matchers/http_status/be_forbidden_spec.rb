require 'spec_helper'

RSpec.describe APIMatchers::HTTPStatus::BeForbidden do
  describe "actual.to be_forbidden" do
    it "passes for status 403" do
      expect(403).to be_forbidden
    end

    it "fails for status 200" do
      expect {
        expect(200).to be_forbidden
      }.to fail_with("expected response to be forbidden (403). Got: 200")
    end

    it "fails for status 401" do
      expect {
        expect(401).to be_forbidden
      }.to fail_with("expected response to be forbidden (403). Got: 401")
    end
  end

  describe "actual.not_to be_forbidden" do
    it "passes for non-403 status" do
      expect(200).not_to be_forbidden
    end

    it "fails for 403 status" do
      expect {
        expect(403).not_to be_forbidden
      }.to fail_with("expected response NOT to be forbidden (403). Got: 403")
    end
  end
end
