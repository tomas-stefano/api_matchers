require 'spec_helper'

RSpec.describe APIMatchers::HTTPStatus::BeUnprocessable do
  describe "actual.to be_unprocessable" do
    it "passes for status 422" do
      expect(422).to be_unprocessable
    end

    it "fails for status 200" do
      expect {
        expect(200).to be_unprocessable
      }.to fail_with("expected response to be unprocessable (422). Got: 200")
    end

    it "fails for status 400" do
      expect {
        expect(400).to be_unprocessable
      }.to fail_with("expected response to be unprocessable (422). Got: 400")
    end
  end

  describe "actual.not_to be_unprocessable" do
    it "passes for non-422 status" do
      expect(200).not_to be_unprocessable
    end

    it "fails for 422 status" do
      expect {
        expect(422).not_to be_unprocessable
      }.to fail_with("expected response NOT to be unprocessable (422). Got: 422")
    end
  end

  describe "alias be_unprocessable_entity" do
    it "works as alias for be_unprocessable" do
      expect(422).to be_unprocessable_entity
    end
  end
end
