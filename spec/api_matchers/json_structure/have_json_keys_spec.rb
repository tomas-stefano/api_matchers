require 'spec_helper'

RSpec.describe APIMatchers::JsonStructure::HaveJsonKeys do
  describe "actual.to have_json_keys" do
    context "with JSON string" do
      it "passes when all keys are present" do
        json = '{"id": 1, "name": "John", "email": "john@example.com"}'
        expect(json).to have_json_keys(:id, :name, :email)
      end

      it "passes when checking subset of keys" do
        json = '{"id": 1, "name": "John", "email": "john@example.com"}'
        expect(json).to have_json_keys(:id, :name)
      end

      it "fails when a key is missing" do
        json = '{"id": 1, "name": "John"}'
        expect {
          expect(json).to have_json_keys(:id, :name, :email)
        }.to fail_with(/Missing: \["email"\]/)
      end

      it "fails when multiple keys are missing" do
        json = '{"id": 1}'
        expect {
          expect(json).to have_json_keys(:id, :name, :email)
        }.to fail_with(/Missing: \["name", "email"\]/)
      end
    end

    context "with Hash" do
      it "passes when all keys are present" do
        data = { id: 1, name: "John", email: "john@example.com" }
        expect(data).to have_json_keys(:id, :name, :email)
      end
    end

    context "with at_path" do
      it "checks keys at specified path" do
        json = '{"user": {"id": 1, "name": "John"}}'
        expect(json).to have_json_keys(:id, :name).at_path("user")
      end

      it "fails when path does not exist" do
        json = '{"data": {"id": 1}}'
        expect {
          expect(json).to have_json_keys(:id).at_path("user")
        }.to fail_with(/Missing: \["id"\]/)
      end
    end
  end

  describe "actual.not_to have_json_keys" do
    it "passes when not all keys are present" do
      json = '{"id": 1, "name": "John"}'
      expect(json).not_to have_json_keys(:id, :name, :email)
    end

    it "fails when all keys are present" do
      json = '{"id": 1, "name": "John"}'
      expect {
        expect(json).not_to have_json_keys(:id, :name)
      }.to fail_with(/expected JSON NOT to have keys/)
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
      response = OpenStruct.new(body: '{"id": 1, "name": "John"}')
      expect(response).to have_json_keys(:id, :name)
    end
  end
end
