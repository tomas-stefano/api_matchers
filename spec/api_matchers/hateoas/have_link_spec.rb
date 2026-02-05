require 'spec_helper'

RSpec.describe APIMatchers::Hateoas::HaveLink do
  describe "actual.to have_link" do
    context "with HAL-style links" do
      it "passes when link is present" do
        json = '{"_links": {"self": {"href": "/users/1"}}}'
        expect(json).to have_link(:self)
      end

      it "fails when link is not present" do
        json = '{"_links": {"self": {"href": "/users/1"}}}'
        expect {
          expect(json).to have_link(:next)
        }.to fail_with(/Available links: \["self"\]/)
      end
    end

    context "with simple links object" do
      it "passes when link is present" do
        json = '{"links": {"self": "/users/1"}}'
        expect(json).to have_link(:self)
      end
    end

    context "with with_href (exact match)" do
      it "passes when href matches exactly" do
        json = '{"_links": {"self": {"href": "/users/1"}}}'
        expect(json).to have_link(:self).with_href("/users/1")
      end

      it "fails when href does not match" do
        json = '{"_links": {"self": {"href": "/users/1"}}}'
        expect {
          expect(json).to have_link(:self).with_href("/users/2")
        }.to fail_with(/expected link 'self' to have href '\/users\/2'. Got: '\/users\/1'/)
      end
    end

    context "with with_href (regex)" do
      it "passes when href matches pattern" do
        json = '{"_links": {"self": {"href": "/users/123"}}}'
        expect(json).to have_link(:self).with_href(/\/users\/\d+/)
      end

      it "fails when href does not match pattern" do
        json = '{"_links": {"self": {"href": "/posts/123"}}}'
        expect {
          expect(json).to have_link(:self).with_href(/\/users\/\d+/)
        }.to fail_with(/expected link 'self' href to match/)
      end
    end

    context "with simple string href" do
      it "extracts href from string value" do
        json = '{"links": {"self": "/users/1"}}'
        expect(json).to have_link(:self).with_href("/users/1")
      end
    end

    context "when links not found" do
      it "fails with descriptive message" do
        json = '{"data": {"id": 1}}'
        expect {
          expect(json).to have_link(:self)
        }.to fail_with(/but no links were found/)
      end
    end
  end

  describe "actual.not_to have_link" do
    it "passes when link is not present" do
      json = '{"_links": {"self": {"href": "/users/1"}}}'
      expect(json).not_to have_link(:next)
    end

    it "fails when link is present" do
      json = '{"_links": {"self": {"href": "/users/1"}}}'
      expect {
        expect(json).not_to have_link(:self)
      }.to fail_with(/expected response NOT to have link 'self', but it was present/)
    end
  end

  describe "with configuration" do
    before do
      APIMatchers.setup do |config|
        config.response_body_method = :body
        config.links_path = 'links'
      end
    end

    after do
      APIMatchers.setup do |config|
        config.response_body_method = nil
        config.links_path = nil
      end
    end

    it "uses configured links_path" do
      response = OpenStruct.new(body: '{"links": {"self": {"href": "/users/1"}}}')
      expect(response).to have_link(:self)
    end
  end
end
