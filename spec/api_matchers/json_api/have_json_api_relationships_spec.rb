require 'spec_helper'

RSpec.describe APIMatchers::JsonApi::HaveJsonApiRelationships do
  describe "actual.to have_json_api_relationships" do
    context "with single resource" do
      it "passes when all relationships are present" do
        json = '{"data": {"id": "1", "type": "posts", "relationships": {"author": {"data": {"id": "1", "type": "users"}}, "comments": {"data": []}}}}'
        expect(json).to have_json_api_relationships(:author, :comments)
      end

      it "passes when checking subset of relationships" do
        json = '{"data": {"id": "1", "type": "posts", "relationships": {"author": {"data": {"id": "1", "type": "users"}}, "comments": {"data": []}}}}'
        expect(json).to have_json_api_relationships(:author)
      end

      it "fails when relationship is missing" do
        json = '{"data": {"id": "1", "type": "posts", "relationships": {"author": {"data": {"id": "1", "type": "users"}}}}}'
        expect {
          expect(json).to have_json_api_relationships(:author, :comments)
        }.to fail_with(/Missing: \["comments"\]/)
      end
    end

    context "with array of resources" do
      it "checks relationships of first resource" do
        json = '{"data": [{"id": "1", "type": "posts", "relationships": {"author": {"data": {"id": "1", "type": "users"}}}}, {"id": "2", "type": "posts", "relationships": {"author": {"data": {"id": "2", "type": "users"}}}}]}'
        expect(json).to have_json_api_relationships(:author)
      end
    end

    context "when no relationships found" do
      it "fails when data has no relationships" do
        json = '{"data": {"id": "1", "type": "posts"}}'
        expect {
          expect(json).to have_json_api_relationships(:author)
        }.to fail_with(/but no relationships were found/)
      end

      it "fails when data is missing" do
        json = '{"errors": []}'
        expect {
          expect(json).to have_json_api_relationships(:author)
        }.to fail_with(/but no relationships were found/)
      end
    end
  end

  describe "actual.not_to have_json_api_relationships" do
    it "passes when not all relationships are present" do
      json = '{"data": {"id": "1", "type": "posts", "relationships": {"author": {"data": {"id": "1", "type": "users"}}}}}'
      expect(json).not_to have_json_api_relationships(:comments)
    end

    it "fails when all relationships are present" do
      json = '{"data": {"id": "1", "type": "posts", "relationships": {"author": {"data": {"id": "1", "type": "users"}}, "comments": {"data": []}}}}'
      expect {
        expect(json).not_to have_json_api_relationships(:author, :comments)
      }.to fail_with(/expected JSON:API data NOT to have relationships/)
    end
  end
end
