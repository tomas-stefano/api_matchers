require 'spec_helper'

describe APIMatchers::HTTPStatusCode::CreateResource do
  describe "should create_resource" do
    it "should passes if the actual is equal to 201" do
      expect(201).to create_resource
    end

    it "should fails if the actual is not equal to 201" do
      expect {
        expect(200).to create_resource
      }.to fail_with(%Q{expected that '200' to be Created Resource with the status '201'.})
    end
  end

  describe "should_not create_resource" do
    it "should passes if the actual is not equal to 201" do
      expect(401).not_to create_resource
    end

    it "should fail if the actual is equal equal to 201" do
      expect {
        expect(201).not_to create_resource
      }.to fail_with(%Q{expected that '201' to NOT be Created Resource.})
    end
  end

  describe "with change configuration" do
    before do
      APIMatchers.setup { |config| config.http_status_method = :http_status }
    end

    after do
      APIMatchers.setup { |config| config.http_status_method = nil }
    end

    it "should pass if the actual.http_status is equal to 201" do
      response = OpenStruct.new(:http_status => 201)
      expect(response).to create_resource
    end

    it "should fail if the actual.http_status is not equal to 201" do
      response = OpenStruct.new(:http_status => 402)
      expect {
        expect(response).to create_resource
      }.to fail_with(%Q{expected that '402' to be Created Resource with the status '201'.})
    end
  end
end