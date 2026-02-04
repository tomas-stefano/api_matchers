require 'spec_helper'

RSpec.describe APIMatchers::Headers::HaveCacheControl do
  describe "actual.to have_cache_control" do
    context "with single directive" do
      it "passes when directive is present" do
        headers = { 'Cache-Control' => 'no-cache' }
        expect(headers).to have_cache_control(:no_cache)
      end

      it "fails when directive is not present" do
        headers = { 'Cache-Control' => 'public' }
        expect {
          expect(headers).to have_cache_control(:no_cache)
        }.to fail_with(/expected Cache-Control to include \["no-cache"\]/)
      end
    end

    context "with multiple directives" do
      it "passes when all directives are present" do
        headers = { 'Cache-Control' => 'private, no-store, max-age=0' }
        expect(headers).to have_cache_control(:private, :no_store)
      end

      it "fails when some directives are missing" do
        headers = { 'Cache-Control' => 'private' }
        expect {
          expect(headers).to have_cache_control(:private, :no_store)
        }.to fail_with(/expected Cache-Control to include \["private", "no-store"\]/)
      end
    end

    context "with directives that have values" do
      it "passes when max-age is present" do
        headers = { 'Cache-Control' => 'max-age=3600' }
        expect(headers).to have_cache_control('max-age')
      end

      it "passes when s-maxage is present" do
        headers = { 'Cache-Control' => 's-maxage=7200, public' }
        expect(headers).to have_cache_control('s-maxage', :public)
      end
    end

    context "when Cache-Control header is missing" do
      it "fails with descriptive message" do
        headers = { 'Content-Type' => 'application/json' }
        expect {
          expect(headers).to have_cache_control(:no_cache)
        }.to fail_with(/but Cache-Control header was not present/)
      end
    end

    context "underscore to dash conversion" do
      it "converts underscores to dashes" do
        headers = { 'Cache-Control' => 'no-store, must-revalidate' }
        expect(headers).to have_cache_control(:no_store, :must_revalidate)
      end
    end

    context "case insensitivity" do
      it "matches directives case-insensitively" do
        headers = { 'Cache-Control' => 'NO-CACHE, PRIVATE' }
        expect(headers).to have_cache_control(:no_cache, :private)
      end

      it "matches header name case-insensitively" do
        headers = { 'cache-control' => 'no-cache' }
        expect(headers).to have_cache_control(:no_cache)
      end
    end
  end

  describe "actual.not_to have_cache_control" do
    it "passes when directives are not present" do
      headers = { 'Cache-Control' => 'public' }
      expect(headers).not_to have_cache_control(:private)
    end

    it "fails when directives are present" do
      headers = { 'Cache-Control' => 'private, no-cache' }
      expect {
        expect(headers).not_to have_cache_control(:private)
      }.to fail_with(/expected Cache-Control NOT to include \["private"\]/)
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
      response = OpenStruct.new(response_headers: { 'Cache-Control' => 'no-cache' })
      expect(response).to have_cache_control(:no_cache)
    end
  end
end
