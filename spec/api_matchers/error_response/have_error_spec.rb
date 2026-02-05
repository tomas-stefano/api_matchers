require 'spec_helper'

RSpec.describe APIMatchers::ErrorResponse::HaveError do
  describe "actual.to have_error" do
    context "with errors array" do
      it "passes when errors array is present" do
        json = '{"errors": [{"message": "Name is required"}]}'
        expect(json).to have_error
      end

      it "passes when errors array has multiple errors" do
        json = '{"errors": [{"message": "Name is required"}, {"message": "Email is invalid"}]}'
        expect(json).to have_errors
      end

      it "fails when errors array is empty" do
        json = '{"errors": []}'
        expect {
          expect(json).to have_error
        }.to fail_with(/expected response to have error/)
      end
    end

    context "with error object" do
      it "passes when error key is present" do
        json = '{"error": "Something went wrong"}'
        expect(json).to have_error
      end

      it "passes when error is an object" do
        json = '{"error": {"code": "INVALID", "message": "Invalid input"}}'
        expect(json).to have_error
      end
    end

    context "with message key" do
      it "passes when message is present" do
        json = '{"message": "Resource not found"}'
        expect(json).to have_error
      end
    end

    context "with errors at configured path" do
      before do
        APIMatchers.setup { |config| config.errors_path = 'response.errors' }
      end

      after do
        APIMatchers.setup { |config| config.errors_path = nil }
      end

      it "finds errors at configured path" do
        json = '{"response": {"errors": [{"message": "Error"}]}}'
        expect(json).to have_error
      end
    end

    context "when no errors found" do
      it "fails with descriptive message" do
        json = '{"data": {"id": 1}}'
        expect {
          expect(json).to have_error
        }.to fail_with(/expected response to have error/)
      end
    end
  end

  describe "actual.not_to have_error" do
    it "passes when no errors present" do
      json = '{"data": {"id": 1}}'
      expect(json).not_to have_error
    end

    it "passes when errors array is empty" do
      json = '{"errors": []}'
      expect(json).not_to have_errors
    end

    it "fails when errors are present" do
      json = '{"errors": [{"message": "Error"}]}'
      expect {
        expect(json).not_to have_error
      }.to fail_with(/expected response NOT to have error/)
    end
  end

  describe "alias have_errors" do
    it "works as alias for have_error" do
      json = '{"errors": [{"message": "Error"}]}'
      expect(json).to have_errors
    end
  end

  describe "with configuration" do
    before do
      APIMatchers.setup { |config| config.response_body_method = :body }
    end

    after do
      APIMatchers.setup { |config| config.response_body_method = nil }
    end

    it "extracts body from response object" do
      response = OpenStruct.new(body: '{"errors": [{"message": "Error"}]}')
      expect(response).to have_error
    end
  end
end
