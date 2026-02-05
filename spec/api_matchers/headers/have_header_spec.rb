require 'spec_helper'

RSpec.describe APIMatchers::Headers::HaveHeader do
  describe "actual.to have_header" do
    context "with hash headers" do
      it "passes when header is present" do
        headers = { 'Content-Type' => 'application/json' }
        expect(headers).to have_header('Content-Type')
      end

      it "fails when header is not present" do
        headers = { 'Content-Type' => 'application/json' }
        expect {
          expect(headers).to have_header('X-Custom-Header')
        }.to fail_with(/expected response to have header 'X-Custom-Header', but it was not present/)
      end

      it "is case-insensitive" do
        headers = { 'content-type' => 'application/json' }
        expect(headers).to have_header('Content-Type')
      end
    end

    context "with with_value" do
      it "passes when header has expected value" do
        headers = { 'X-Request-Id' => '12345' }
        expect(headers).to have_header('X-Request-Id').with_value('12345')
      end

      it "fails when header has different value" do
        headers = { 'X-Request-Id' => '12345' }
        expect {
          expect(headers).to have_header('X-Request-Id').with_value('67890')
        }.to fail_with(/expected header 'X-Request-Id' to have value '67890'. Got: '12345'/)
      end
    end

    context "with matching (regex)" do
      it "passes when header matches pattern" do
        headers = { 'X-Request-Id' => 'req-12345-abc' }
        expect(headers).to have_header('X-Request-Id').matching(/req-\d+-\w+/)
      end

      it "fails when header does not match pattern" do
        headers = { 'X-Request-Id' => 'invalid' }
        expect {
          expect(headers).to have_header('X-Request-Id').matching(/req-\d+-\w+/)
        }.to fail_with(/expected header 'X-Request-Id' to match/)
      end
    end
  end

  describe "actual.not_to have_header" do
    it "passes when header is not present" do
      headers = { 'Content-Type' => 'application/json' }
      expect(headers).not_to have_header('X-Custom-Header')
    end

    it "fails when header is present" do
      headers = { 'X-Custom-Header' => 'value' }
      expect {
        expect(headers).not_to have_header('X-Custom-Header')
      }.to fail_with(/expected response NOT to have header 'X-Custom-Header', but it was present/)
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
      response = OpenStruct.new(response_headers: { 'X-Custom' => 'value' })
      expect(response).to have_header('X-Custom')
    end
  end

  describe "with response object having headers method" do
    it "automatically uses headers method" do
      response = OpenStruct.new(headers: { 'X-Custom' => 'value' })
      expect(response).to have_header('X-Custom')
    end
  end
end
