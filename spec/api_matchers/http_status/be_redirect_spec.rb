require 'spec_helper'

RSpec.describe APIMatchers::HTTPStatus::BeRedirect do
  describe "actual.to be_redirect" do
    it "passes for status 300" do
      expect(300).to be_redirect
    end

    it "passes for status 301" do
      expect(301).to be_redirect
    end

    it "passes for status 302" do
      expect(302).to be_redirect
    end

    it "passes for status 307" do
      expect(307).to be_redirect
    end

    it "passes for status 308" do
      expect(308).to be_redirect
    end

    it "fails for status 200" do
      expect {
        expect(200).to be_redirect
      }.to fail_with("expected response to be redirect (3xx). Got: 200")
    end

    it "fails for status 400" do
      expect {
        expect(400).to be_redirect
      }.to fail_with("expected response to be redirect (3xx). Got: 400")
    end
  end

  describe "actual.not_to be_redirect" do
    it "passes for non-3xx status" do
      expect(200).not_to be_redirect
    end

    it "fails for 3xx status" do
      expect {
        expect(302).not_to be_redirect
      }.to fail_with("expected response NOT to be redirect (3xx). Got: 302")
    end
  end

  describe "alias be_redirection" do
    it "works as alias for be_redirect" do
      expect(301).to be_redirection
    end
  end
end
