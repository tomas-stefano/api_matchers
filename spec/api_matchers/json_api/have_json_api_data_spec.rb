require 'spec_helper'

RSpec.describe APIMatchers::JsonApi::HaveJsonApiData do
  describe "actual.to have_json_api_data" do
    context "basic data presence" do
      it "passes when data is present" do
        json = '{"data": {"id": "1", "type": "users"}}'
        expect(json).to have_json_api_data
      end

      it "passes when data is null" do
        json = '{"data": null}'
        expect(json).to have_json_api_data
      end

      it "passes when data is an array" do
        json = '{"data": [{"id": "1", "type": "users"}]}'
        expect(json).to have_json_api_data
      end

      it "fails when data is missing" do
        json = '{"errors": []}'
        expect {
          expect(json).to have_json_api_data
        }.to fail_with(/expected response to have JSON:API data/)
      end
    end

    context "with of_type" do
      it "passes when type matches" do
        json = '{"data": {"id": "1", "type": "users"}}'
        expect(json).to have_json_api_data.of_type("users")
      end

      it "passes when type matches for array" do
        json = '{"data": [{"id": "1", "type": "users"}, {"id": "2", "type": "users"}]}'
        expect(json).to have_json_api_data.of_type(:users)
      end

      it "fails when type does not match" do
        json = '{"data": {"id": "1", "type": "posts"}}'
        expect {
          expect(json).to have_json_api_data.of_type("users")
        }.to fail_with(/expected JSON:API data to have type 'users'. Got type: 'posts'/)
      end
    end

    context "with with_id" do
      it "passes when id matches" do
        json = '{"data": {"id": "123", "type": "users"}}'
        expect(json).to have_json_api_data.with_id("123")
      end

      it "passes when id is in array" do
        json = '{"data": [{"id": "1", "type": "users"}, {"id": "2", "type": "users"}]}'
        expect(json).to have_json_api_data.with_id("2")
      end

      it "fails when id does not match" do
        json = '{"data": {"id": "123", "type": "users"}}'
        expect {
          expect(json).to have_json_api_data.with_id("456")
        }.to fail_with(/expected JSON:API data to have id '456'. Got id: '123'/)
      end
    end

    context "combining of_type and with_id" do
      it "passes when both match" do
        json = '{"data": {"id": "123", "type": "users"}}'
        expect(json).to have_json_api_data.of_type("users").with_id("123")
      end

      it "fails when type does not match" do
        json = '{"data": {"id": "123", "type": "posts"}}'
        expect {
          expect(json).to have_json_api_data.of_type("users").with_id("123")
        }.to fail_with(/expected JSON:API data to have type 'users'/)
      end
    end
  end

  describe "actual.not_to have_json_api_data" do
    it "passes when data is missing" do
      json = '{"errors": []}'
      expect(json).not_to have_json_api_data
    end

    it "fails when data is present" do
      json = '{"data": {"id": "1", "type": "users"}}'
      expect {
        expect(json).not_to have_json_api_data
      }.to fail_with(/expected response NOT to have JSON:API data/)
    end
  end
end
