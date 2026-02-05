require 'spec_helper'

RSpec.describe APIMatchers::Pagination::BePaginated do
  describe "actual.to be_paginated" do
    context "with pagination in meta" do
      it "passes when meta has page" do
        json = '{"data": [], "meta": {"page": 1, "per_page": 10}}'
        expect(json).to be_paginated
      end

      it "passes when meta has total_count" do
        json = '{"data": [], "meta": {"total_count": 100}}'
        expect(json).to be_paginated
      end

      it "passes when meta has offset/limit" do
        json = '{"data": [], "meta": {"offset": 0, "limit": 10}}'
        expect(json).to be_paginated
      end
    end

    context "with pagination links" do
      it "passes when links has next" do
        json = '{"data": [], "links": {"next": "/api/users?page=2"}}'
        expect(json).to be_paginated
      end

      it "passes when links has prev" do
        json = '{"data": [], "links": {"prev": "/api/users?page=1"}}'
        expect(json).to be_paginated
      end

      it "passes when links has first/last" do
        json = '{"data": [], "links": {"first": "/api/users?page=1", "last": "/api/users?page=10"}}'
        expect(json).to be_paginated
      end
    end

    context "with pagination at root level" do
      it "passes when root has page" do
        json = '{"items": [], "page": 1, "per_page": 10}'
        expect(json).to be_paginated
      end

      it "passes when root has total" do
        json = '{"items": [], "total": 100}'
        expect(json).to be_paginated
      end
    end

    context "when not paginated" do
      it "fails when no pagination keys found" do
        json = '{"data": [{"id": 1}]}'
        expect {
          expect(json).to be_paginated
        }.to fail_with(/expected response to be paginated/)
      end
    end
  end

  describe "actual.not_to be_paginated" do
    it "passes when not paginated" do
      json = '{"data": [{"id": 1}]}'
      expect(json).not_to be_paginated
    end

    it "fails when paginated" do
      json = '{"data": [], "meta": {"page": 1}}'
      expect {
        expect(json).not_to be_paginated
      }.to fail_with(/expected response NOT to be paginated/)
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
      response = OpenStruct.new(body: '{"data": [], "pagination": {"page": 1}}')
      expect(response).to be_paginated
    end
  end
end
