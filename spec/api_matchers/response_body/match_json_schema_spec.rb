require 'spec_helper'

RSpec.describe APIMatchers::ResponseBody::MatchJsonSchema do
  let(:schema) do
    {
      type: "object",
      required: ["id", "name"],
      properties: {
        id: { type: "integer" },
        name: { type: "string" },
        email: { type: "string" }
      }
    }
  end

  describe "actual.to match_json_schema" do
    it "passes when JSON matches the schema" do
      json = '{"id": 1, "name": "John", "email": "john@example.com"}'
      expect(json).to match_json_schema(schema)
    end

    it "passes when JSON has extra properties not in schema" do
      json = '{"id": 1, "name": "John", "extra": "field"}'
      expect(json).to match_json_schema(schema)
    end

    it "fails when required property is missing" do
      json = '{"id": 1}'
      expect {
        expect(json).to match_json_schema(schema)
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError, /Expected JSON to match schema/)
    end

    it "fails when property has wrong type" do
      json = '{"id": "not_an_integer", "name": "John"}'
      expect {
        expect(json).to match_json_schema(schema)
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError, /Expected JSON to match schema/)
    end
  end

  describe "actual.not_to match_json_schema" do
    it "passes when JSON does not match schema" do
      json = '{"id": 1}'
      expect(json).not_to match_json_schema(schema)
    end

    it "fails when JSON matches schema" do
      json = '{"id": 1, "name": "John"}'
      expect {
        expect(json).not_to match_json_schema(schema)
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError, /Expected JSON to NOT match schema/)
    end
  end

  describe "with string schema" do
    it "accepts schema as JSON string" do
      json = '{"id": 1, "name": "John"}'
      schema_string = '{"type": "object", "required": ["id"], "properties": {"id": {"type": "integer"}}}'
      expect(json).to match_json_schema(schema_string)
    end
  end

  describe "with invalid JSON" do
    it "raises InvalidJSON error" do
      expect {
        expect("not valid json").to match_json_schema(schema)
      }.to raise_error(APIMatchers::InvalidJSON)
    end
  end

  describe "with response_body_method configured" do
    before do
      APIMatchers.setup { |config| config.response_body_method = :body }
    end

    after do
      APIMatchers.setup { |config| config.response_body_method = nil }
    end

    it "uses configured method to get response body" do
      response = OpenStruct.new(body: '{"id": 1, "name": "John"}')
      expect(response).to match_json_schema(schema)
    end
  end
end
