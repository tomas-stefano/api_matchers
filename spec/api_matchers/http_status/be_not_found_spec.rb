require 'spec_helper'

RSpec.describe APIMatchers::HTTPStatus::BeNotFound do
  describe "actual.to be_not_found" do
    it "passes for status 404" do
      expect(404).to be_not_found
    end

    it "fails for status 200" do
      expect {
        expect(200).to be_not_found
      }.to fail_with("expected response to be not found (404). Got: 200")
    end

    it "fails for status 500" do
      expect {
        expect(500).to be_not_found
      }.to fail_with("expected response to be not found (404). Got: 500")
    end

    it "fails for other 4xx status" do
      expect {
        expect(401).to be_not_found
      }.to fail_with("expected response to be not found (404). Got: 401")
    end
  end

  describe "actual.not_to be_not_found" do
    it "passes for non-404 status" do
      expect(200).not_to be_not_found
    end

    it "fails for 404 status" do
      expect {
        expect(404).not_to be_not_found
      }.to fail_with("expected response NOT to be not found (404). Got: 404")
    end
  end
end
