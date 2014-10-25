require 'spec_helper'

RSpec.describe APIMatchers::HTTPStatusCode::BeUnprocessableEntity do
  describe "should be_unprocessable_entity" do
    it "should passes if the actual is equal to 422" do
      expect(422).to be_unprocessable_entity
    end

    it "should fails if the actual is not equal to 422" do
      expect {
        expect(500).to be_unprocessable_entity
      }.to fail_with(%Q{expected that '500' to be Unprocessable entity with the status '422'.})
    end
  end

  describe "should_not be_unprocessable_entity" do
    it "should passes if the actual is not equal to 200" do
      expect(400).not_to be_unprocessable_entity
    end

    it "should fail if the actual is equal to 200" do
      expect {
        expect(422).not_to be_unprocessable_entity
      }.to fail_with(%Q{expected that '422' to NOT be Unprocessable entity with the status '422'.})
    end
  end
end