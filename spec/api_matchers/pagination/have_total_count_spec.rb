require 'spec_helper'

RSpec.describe APIMatchers::Pagination::HaveTotalCount do
  describe "actual.to have_total_count" do
    context "with total in meta" do
      it "passes when total matches" do
        json = '{"data": [], "meta": {"total": 100}}'
        expect(json).to have_total_count(100)
      end

      it "passes with total_count key" do
        json = '{"data": [], "meta": {"total_count": 50}}'
        expect(json).to have_total_count(50)
      end

      it "passes with totalCount key (camelCase)" do
        json = '{"data": [], "meta": {"totalCount": 75}}'
        expect(json).to have_total_count(75)
      end

      it "fails when count does not match" do
        json = '{"data": [], "meta": {"total": 100}}'
        expect {
          expect(json).to have_total_count(50)
        }.to fail_with(/expected total count to be 50. Got: 100/)
      end
    end

    context "with total at root level" do
      it "passes when total is at root" do
        json = '{"items": [], "total": 100}'
        expect(json).to have_total_count(100)
      end

      it "passes with count key at root" do
        json = '{"items": [], "count": 25}'
        expect(json).to have_total_count(25)
      end
    end

    context "when total count is not found" do
      it "fails with descriptive message" do
        json = '{"data": []}'
        expect {
          expect(json).to have_total_count(100)
        }.to fail_with(/but no total count field was found/)
      end
    end
  end

  describe "actual.not_to have_total_count" do
    it "passes when count does not match" do
      json = '{"data": [], "meta": {"total": 100}}'
      expect(json).not_to have_total_count(50)
    end

    it "fails when count matches" do
      json = '{"data": [], "meta": {"total": 100}}'
      expect {
        expect(json).not_to have_total_count(100)
      }.to fail_with(/expected total count NOT to be 100, but it was/)
    end
  end

  describe "with configuration" do
    before do
      APIMatchers.setup do |config|
        config.response_body_method = :body
        config.pagination_meta_path = 'pagination'
      end
    end

    after do
      APIMatchers.setup do |config|
        config.response_body_method = nil
        config.pagination_meta_path = nil
      end
    end

    it "uses configured pagination_meta_path" do
      response = OpenStruct.new(body: '{"data": [], "pagination": {"total": 100}}')
      expect(response).to have_total_count(100)
    end
  end
end
