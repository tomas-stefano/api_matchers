require 'spec_helper'

RSpec.describe APIMatchers::JsonApi::BeJsonApiCompliant do
  describe "actual.to be_json_api_compliant" do
    context "with valid JSON:API structure" do
      it "passes with data object" do
        json = '{"data": {"id": "1", "type": "users", "attributes": {"name": "John"}}}'
        expect(json).to be_json_api_compliant
      end

      it "passes with data array" do
        json = '{"data": [{"id": "1", "type": "users"}, {"id": "2", "type": "users"}]}'
        expect(json).to be_json_api_compliant
      end

      it "passes with null data" do
        json = '{"data": null}'
        expect(json).to be_json_api_compliant
      end

      it "passes with errors array" do
        json = '{"errors": [{"status": "404", "title": "Not Found"}]}'
        expect(json).to be_json_api_compliant
      end

      it "passes with meta only" do
        json = '{"meta": {"total": 100}}'
        expect(json).to be_json_api_compliant
      end

      it "passes with relationships" do
        json = '{"data": {"id": "1", "type": "posts", "relationships": {"author": {"data": {"id": "1", "type": "users"}}}}}'
        expect(json).to be_json_api_compliant
      end
    end

    context "with invalid JSON:API structure" do
      it "fails when top level is not an object" do
        json = '[1, 2, 3]'
        expect {
          expect(json).to be_json_api_compliant
        }.to fail_with(/top-level must be an object/)
      end

      it "fails when missing data, errors, and meta" do
        json = '{"included": []}'
        expect {
          expect(json).to be_json_api_compliant
        }.to fail_with(/must contain at least one of: data, errors, or meta/)
      end

      it "fails when data and errors coexist" do
        json = '{"data": {"id": "1", "type": "users"}, "errors": []}'
        expect {
          expect(json).to be_json_api_compliant
        }.to fail_with(/data and errors must not coexist/)
      end

      it "fails when resource is missing type" do
        json = '{"data": {"id": "1"}}'
        expect {
          expect(json).to be_json_api_compliant
        }.to fail_with(/must contain 'type'/)
      end

      it "fails when type is not a string" do
        json = '{"data": {"id": "1", "type": 123}}'
        expect {
          expect(json).to be_json_api_compliant
        }.to fail_with(/type must be a string/)
      end

      it "fails when attributes is not an object" do
        json = '{"data": {"id": "1", "type": "users", "attributes": "invalid"}}'
        expect {
          expect(json).to be_json_api_compliant
        }.to fail_with(/attributes must be an object/)
      end

      it "fails when relationships is not an object" do
        json = '{"data": {"id": "1", "type": "users", "relationships": "invalid"}}'
        expect {
          expect(json).to be_json_api_compliant
        }.to fail_with(/relationships must be an object/)
      end

      it "fails when errors is not an array" do
        json = '{"errors": {"message": "error"}}'
        expect {
          expect(json).to be_json_api_compliant
        }.to fail_with(/errors must be an array/)
      end
    end
  end

  describe "actual.not_to be_json_api_compliant" do
    it "passes when not compliant" do
      json = '{"result": "success"}'
      expect(json).not_to be_json_api_compliant
    end

    it "fails when compliant" do
      json = '{"data": {"id": "1", "type": "users"}}'
      expect {
        expect(json).not_to be_json_api_compliant
      }.to fail_with(/expected response NOT to be JSON:API compliant/)
    end
  end
end
