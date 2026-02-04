require 'spec_helper'

RSpec.describe APIMatchers::HTTPStatus::HaveHttpStatus do
  describe "actual.to have_http_status" do
    context "with integer status code" do
      it "passes when the status matches" do
        expect(200).to have_http_status(200)
      end

      it "fails when the status does not match" do
        expect {
          expect(404).to have_http_status(200)
        }.to fail_with("expected response to have HTTP status 200. Got: 404")
      end
    end

    context "with symbol status code" do
      it "passes when the status matches :ok" do
        expect(200).to have_http_status(:ok)
      end

      it "passes when the status matches :created" do
        expect(201).to have_http_status(:created)
      end

      it "passes when the status matches :not_found" do
        expect(404).to have_http_status(:not_found)
      end

      it "passes when the status matches :unprocessable_entity" do
        expect(422).to have_http_status(:unprocessable_entity)
      end

      it "fails when the status does not match" do
        expect {
          expect(500).to have_http_status(:ok)
        }.to fail_with("expected response to have HTTP status 200 (ok). Got: 500")
      end

      it "raises error for unknown symbol" do
        expect {
          expect(200).to have_http_status(:unknown_status)
        }.to raise_error(ArgumentError, /Unknown status code symbol/)
      end
    end
  end

  describe "actual.not_to have_http_status" do
    it "passes when the status does not match" do
      expect(404).not_to have_http_status(200)
    end

    it "fails when the status matches" do
      expect {
        expect(200).not_to have_http_status(200)
      }.to fail_with("expected response NOT to have HTTP status 200. Got: 200")
    end
  end

  describe "with configuration" do
    before do
      APIMatchers.setup { |config| config.http_status_method = :status }
    end

    after do
      APIMatchers.setup { |config| config.http_status_method = nil }
    end

    it "extracts status from response object" do
      response = OpenStruct.new(status: 200)
      expect(response).to have_http_status(:ok)
    end

    it "fails when response status does not match" do
      response = OpenStruct.new(status: 404)
      expect {
        expect(response).to have_http_status(:ok)
      }.to fail_with(/expected response to have HTTP status 200/)
    end
  end
end
