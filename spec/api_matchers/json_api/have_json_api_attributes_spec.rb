require 'spec_helper'

RSpec.describe APIMatchers::JsonApi::HaveJsonApiAttributes do
  describe "actual.to have_json_api_attributes" do
    context "with single resource" do
      it "passes when all attributes are present" do
        json = '{"data": {"id": "1", "type": "users", "attributes": {"name": "John", "email": "john@example.com"}}}'
        expect(json).to have_json_api_attributes(:name, :email)
      end

      it "passes when checking subset of attributes" do
        json = '{"data": {"id": "1", "type": "users", "attributes": {"name": "John", "email": "john@example.com", "age": 30}}}'
        expect(json).to have_json_api_attributes(:name)
      end

      it "fails when attribute is missing" do
        json = '{"data": {"id": "1", "type": "users", "attributes": {"name": "John"}}}'
        expect {
          expect(json).to have_json_api_attributes(:name, :email)
        }.to fail_with(/Missing: \["email"\]/)
      end
    end

    context "with array of resources" do
      it "checks attributes of first resource" do
        json = '{"data": [{"id": "1", "type": "users", "attributes": {"name": "John"}}, {"id": "2", "type": "users", "attributes": {"name": "Jane"}}]}'
        expect(json).to have_json_api_attributes(:name)
      end
    end

    context "when no attributes found" do
      it "fails when data has no attributes" do
        json = '{"data": {"id": "1", "type": "users"}}'
        expect {
          expect(json).to have_json_api_attributes(:name)
        }.to fail_with(/but no attributes were found/)
      end

      it "fails when data is missing" do
        json = '{"errors": []}'
        expect {
          expect(json).to have_json_api_attributes(:name)
        }.to fail_with(/but no attributes were found/)
      end
    end
  end

  describe "actual.not_to have_json_api_attributes" do
    it "passes when not all attributes are present" do
      json = '{"data": {"id": "1", "type": "users", "attributes": {"name": "John"}}}'
      expect(json).not_to have_json_api_attributes(:email)
    end

    it "fails when all attributes are present" do
      json = '{"data": {"id": "1", "type": "users", "attributes": {"name": "John", "email": "john@example.com"}}}'
      expect {
        expect(json).not_to have_json_api_attributes(:name, :email)
      }.to fail_with(/expected JSON:API data NOT to have attributes/)
    end
  end
end
