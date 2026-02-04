require 'spec_helper'

RSpec.describe APIMatchers::ErrorResponse::HaveErrorOn do
  describe "actual.to have_error_on" do
    context "with array of error objects (standard API style)" do
      it "passes when error exists on field" do
        json = '{"errors": [{"field": "email", "message": "is invalid"}]}'
        expect(json).to have_error_on(:email)
      end

      it "fails when no error on field" do
        json = '{"errors": [{"field": "name", "message": "is required"}]}'
        expect {
          expect(json).to have_error_on(:email)
        }.to fail_with(/Found errors on: \["name"\]/)
      end
    end

    context "with Rails-style errors hash" do
      it "passes when error exists on field" do
        json = '{"email": ["is invalid", "is already taken"]}'
        expect(json).to have_error_on(:email)
      end

      it "fails when no error on field" do
        json = '{"name": ["is required"]}'
        expect {
          expect(json).to have_error_on(:email)
        }.to fail_with(/Found errors on: \["name"\]/)
      end
    end

    context "with with_message" do
      it "passes when message matches" do
        json = '{"errors": [{"field": "email", "message": "is invalid"}]}'
        expect(json).to have_error_on(:email).with_message("is invalid")
      end

      it "fails when message does not match" do
        json = '{"errors": [{"field": "email", "message": "is invalid"}]}'
        expect {
          expect(json).to have_error_on(:email).with_message("can't be blank")
        }.to fail_with(/expected error on 'email' to have message/)
      end

      it "works with Rails-style errors" do
        json = '{"email": ["is invalid", "is already taken"]}'
        expect(json).to have_error_on(:email).with_message("is invalid")
      end
    end

    context "with matching (regex)" do
      it "passes when message matches pattern" do
        json = '{"errors": [{"field": "email", "message": "Email format is invalid"}]}'
        expect(json).to have_error_on(:email).matching(/invalid/i)
      end

      it "fails when message does not match pattern" do
        json = '{"errors": [{"field": "email", "message": "is required"}]}'
        expect {
          expect(json).to have_error_on(:email).matching(/invalid/)
        }.to fail_with(/expected error on 'email' to match/)
      end
    end

    context "when no errors found" do
      it "fails with descriptive message" do
        json = '{"data": {"id": 1}}'
        expect {
          expect(json).to have_error_on(:email)
        }.to fail_with(/but no errors were found/)
      end
    end

    context "with attribute key instead of field" do
      it "works with attribute key" do
        json = '{"errors": [{"attribute": "email", "message": "is invalid"}]}'
        expect(json).to have_error_on(:email)
      end
    end
  end

  describe "actual.not_to have_error_on" do
    it "passes when no error on field" do
      json = '{"errors": [{"field": "name", "message": "is required"}]}'
      expect(json).not_to have_error_on(:email)
    end

    it "fails when error exists on field" do
      json = '{"errors": [{"field": "email", "message": "is invalid"}]}'
      expect {
        expect(json).not_to have_error_on(:email)
      }.to fail_with(/expected NOT to have error on 'email'/)
    end
  end

  describe "with configuration" do
    before do
      APIMatchers.setup do |config|
        config.response_body_method = :body
        config.errors_path = 'response.errors'
        config.error_field_key = 'attribute'
        config.error_message_key = 'detail'
      end
    end

    after do
      APIMatchers.setup do |config|
        config.response_body_method = nil
        config.errors_path = nil
        config.error_field_key = nil
        config.error_message_key = nil
      end
    end

    it "uses configured paths and keys" do
      response = OpenStruct.new(
        body: '{"response": {"errors": [{"attribute": "email", "detail": "is invalid"}]}}'
      )
      expect(response).to have_error_on(:email).with_message("is invalid")
    end
  end
end
