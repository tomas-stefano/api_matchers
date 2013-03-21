require 'spec_helper'

describe APIMatchers::HTTPStatusCode::BeBadRequest do
  describe "should be_not_found" do
    it "should passes if the actual is equal to 404" do
      404.should be_not_found
    end

    it "should fails if the actual is not equal to 404" do
      expect { 401.should be_not_found }.to fail_with(%Q{expected that '401' to be Not Found with the status '404'.})
    end
  end

  describe "should_not be_not_found" do
    it "should passes if the actual is not equal to 404" do
      401.should_not be_not_found
    end

    it "should fail if the actual is equal to 404" do
      expect { 404.should_not be_not_found }.to fail_with(%Q{expected that '404' to NOT be Not Found with the status '404'.})
    end
  end

  describe "with change configuration" do
    before do
      APIMatchers.setup { |config| config.http_status_method = :http_status }
    end

    after do
      APIMatchers.setup { |config| config.http_status_method = nil }
    end

    it "should pass if the actual.http_status is equal to 404" do
      response = OpenStruct.new(:http_status => 404)
      response.should be_not_found
    end

    it "should fail if the actual.http_status is not equal to 400" do
      response = OpenStruct.new(:http_status => 500)
      expect { response.should be_not_found }.to fail_with(%Q{expected that '500' to be Not Found with the status '404'.})
    end
  end
end