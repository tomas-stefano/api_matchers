require 'spec_helper'

RSpec.describe APIMatchers::Pagination::HavePaginationLinks do
  describe "actual.to have_pagination_links" do
    context "with standard links" do
      it "passes when specified links are present" do
        json = '{"data": [], "links": {"next": "/page/2", "prev": "/page/1"}}'
        expect(json).to have_pagination_links(:next, :prev)
      end

      it "passes when checking single link" do
        json = '{"data": [], "links": {"next": "/page/2"}}'
        expect(json).to have_pagination_links(:next)
      end

      it "fails when links are missing" do
        json = '{"data": [], "links": {"next": "/page/2"}}'
        expect {
          expect(json).to have_pagination_links(:next, :prev)
        }.to fail_with(/Missing: \["prev"\]/)
      end
    end

    context "with various link names" do
      it "passes with first/last links" do
        json = '{"data": [], "links": {"first": "/page/1", "last": "/page/10"}}'
        expect(json).to have_pagination_links(:first, :last)
      end

      it "treats previous as prev" do
        json = '{"data": [], "links": {"previous": "/page/1"}}'
        expect(json).to have_pagination_links(:prev)
      end
    end

    context "when links path does not exist" do
      it "fails with descriptive message" do
        json = '{"data": []}'
        expect {
          expect(json).to have_pagination_links(:next)
        }.to fail_with(/but no links were found/)
      end
    end
  end

  describe "actual.not_to have_pagination_links" do
    it "passes when links are not present" do
      json = '{"data": [], "links": {"self": "/current"}}'
      expect(json).not_to have_pagination_links(:next, :prev)
    end

    it "fails when all specified links are present" do
      json = '{"data": [], "links": {"next": "/page/2", "prev": "/page/1"}}'
      expect {
        expect(json).not_to have_pagination_links(:next, :prev)
      }.to fail_with(/expected response NOT to have pagination links/)
    end
  end

  describe "with configuration" do
    before do
      APIMatchers.setup do |config|
        config.response_body_method = :body
        config.pagination_links_path = '_links'
      end
    end

    after do
      APIMatchers.setup do |config|
        config.response_body_method = nil
        config.pagination_links_path = nil
      end
    end

    it "uses configured pagination_links_path" do
      response = OpenStruct.new(body: '{"data": [], "_links": {"next": "/page/2"}}')
      expect(response).to have_pagination_links(:next)
    end
  end
end
