require 'spec_helper'

RSpec.describe APIMatchers::Headers::HaveCorsHeaders do
  describe "actual.to have_cors_headers" do
    context "with required CORS headers" do
      it "passes when Access-Control-Allow-Origin is present" do
        headers = { 'Access-Control-Allow-Origin' => '*' }
        expect(headers).to have_cors_headers
      end

      it "fails when Access-Control-Allow-Origin is missing" do
        headers = { 'Content-Type' => 'application/json' }
        expect {
          expect(headers).to have_cors_headers
        }.to fail_with(/expected response to have CORS headers. Missing: \["Access-Control-Allow-Origin"\]/)
      end
    end

    context "with for_origin" do
      it "passes when origin matches" do
        headers = { 'Access-Control-Allow-Origin' => 'https://example.com' }
        expect(headers).to have_cors_headers.for_origin('https://example.com')
      end

      it "passes when origin is wildcard" do
        headers = { 'Access-Control-Allow-Origin' => '*' }
        expect(headers).to have_cors_headers.for_origin('https://example.com')
      end

      it "fails when origin does not match" do
        headers = { 'Access-Control-Allow-Origin' => 'https://other.com' }
        expect {
          expect(headers).to have_cors_headers.for_origin('https://example.com')
        }.to fail_with(/expected Access-Control-Allow-Origin to be 'https:\/\/example.com' or '\*'/)
      end
    end

    context "case insensitivity" do
      it "matches headers case-insensitively" do
        headers = { 'access-control-allow-origin' => '*' }
        expect(headers).to have_cors_headers
      end
    end
  end

  describe "actual.not_to have_cors_headers" do
    it "passes when CORS headers are not present" do
      headers = { 'Content-Type' => 'application/json' }
      expect(headers).not_to have_cors_headers
    end

    it "fails when CORS headers are present" do
      headers = { 'Access-Control-Allow-Origin' => '*' }
      expect {
        expect(headers).not_to have_cors_headers
      }.to fail_with(/expected response NOT to have CORS headers, but they were present/)
    end
  end

  describe "with configuration" do
    before do
      APIMatchers.setup { |config| config.header_method = :response_headers }
    end

    after do
      APIMatchers.setup { |config| config.header_method = nil }
    end

    it "extracts headers from response object" do
      response = OpenStruct.new(response_headers: { 'Access-Control-Allow-Origin' => '*' })
      expect(response).to have_cors_headers
    end
  end
end
