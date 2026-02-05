require 'spec_helper'

RSpec.describe APIMatchers::HTTPStatus::BeNoContent do
  describe "actual.to be_no_content" do
    it "passes for status 204" do
      expect(204).to be_no_content
    end

    it "fails for status 200" do
      expect {
        expect(200).to be_no_content
      }.to fail_with("expected response to be no content (204). Got: 200")
    end

    it "fails for status 201" do
      expect {
        expect(201).to be_no_content
      }.to fail_with("expected response to be no content (204). Got: 201")
    end
  end

  describe "actual.not_to be_no_content" do
    it "passes for non-204 status" do
      expect(200).not_to be_no_content
    end

    it "fails for 204 status" do
      expect {
        expect(204).not_to be_no_content
      }.to fail_with("expected response NOT to be no content (204). Got: 204")
    end
  end
end
