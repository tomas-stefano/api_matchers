require 'spec_helper'

RSpec.describe APIMatchers::HTTPStatus::BeSuccessful do
  describe "actual.to be_successful" do
    it "passes for status 200" do
      expect(200).to be_successful
    end

    it "passes for status 201" do
      expect(201).to be_successful
    end

    it "passes for status 204" do
      expect(204).to be_successful
    end

    it "passes for status 299" do
      expect(299).to be_successful
    end

    it "fails for status 199" do
      expect {
        expect(199).to be_successful
      }.to fail_with("expected response to be successful (2xx). Got: 199")
    end

    it "fails for status 300" do
      expect {
        expect(300).to be_successful
      }.to fail_with("expected response to be successful (2xx). Got: 300")
    end

    it "fails for status 404" do
      expect {
        expect(404).to be_successful
      }.to fail_with("expected response to be successful (2xx). Got: 404")
    end

    it "fails for status 500" do
      expect {
        expect(500).to be_successful
      }.to fail_with("expected response to be successful (2xx). Got: 500")
    end
  end

  describe "actual.not_to be_successful" do
    it "passes for non-2xx status" do
      expect(404).not_to be_successful
    end

    it "fails for 2xx status" do
      expect {
        expect(200).not_to be_successful
      }.to fail_with("expected response NOT to be successful (2xx). Got: 200")
    end
  end

  describe "alias be_success" do
    it "works as alias for be_successful" do
      expect(200).to be_success
    end
  end

  describe "with configuration" do
    before do
      APIMatchers.setup { |config| config.http_status_method = :code }
    end

    after do
      APIMatchers.setup { |config| config.http_status_method = nil }
    end

    it "extracts status from response object" do
      response = OpenStruct.new(code: 200)
      expect(response).to be_successful
    end
  end
end
