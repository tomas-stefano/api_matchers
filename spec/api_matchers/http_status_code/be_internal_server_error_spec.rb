require 'spec_helper'

describe APIMatchers::HTTPStatusCode::BeInternalServerError do
  describe "should be_internal_server_error" do
    it "should passes if the actual is equal to 500" do
      500.should be_internal_server_error
    end

    it "should fails if the actual is not equal to 500" do
      expect { 401.should be_internal_server_error }.to fail_with(%Q{expected that '401' to be Internal Server Error with the status '500'.})
    end
  end

  describe "should_not be_internal_server_error" do
    it "should passes if the actual is not equal to 500" do
      400.should_not be_internal_server_error
    end

    it "should fail if the actual is equal to 500" do
      expect { 500.should_not be_internal_server_error }.to fail_with(%Q{expected that '500' to NOT be Internal Server Error.})
    end
  end

  describe "with change configuration" do
    before do
      APIMatchers.setup { |config| config.http_status_method = :http_status }
    end

    after do
      APIMatchers.setup { |config| config.http_status_method = nil }
    end

    it "should pass if the actual.http_status is equal to 500" do
      response = OpenStruct.new(:http_status => 500)
      response.should be_internal_server_error
    end

    it "should fail if the actual.http_status is not equal to 500" do
      response = OpenStruct.new(:http_status => 402)
      expect { response.should be_internal_server_error }.to fail_with(%Q{expected that '402' to be Internal Server Error with the status '500'.})
    end
  end
end