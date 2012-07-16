module APIMatchers
  module Core
    class Setup
      # The http status method that will be called when you call http status matchers
      #
      # ==== Examples
      #
      #  response.status.should create_resource
      #  response.status.should be_bad_request
      #  response.status.should be_unauthorized
      #
      #  # Instead calling #status everytime, you can configure:
      #
      #  APIMatchers.setup do |config|
      #    config.http_status_method = :status
      #  end
      #
      # Then:
      #
      #  response.should create_resource
      #  response.should be_bad_request
      #  response.should be_unauthorized
      #
      cattr_accessor :http_status_method

      # The response body method that will be called when you call the have_node matchers
      #
      # ==== Examples
      #
      #  response.body.should have_node(:foo)
      #  response.body.should have_node(:bar)
      #  response.body.should have_node(:baz)
      #
      #  # Instead calling #body everytime, you can configure:
      #
      #  APIMatchers.setup do |config|
      #    config.http_status_method = :body
      #  end
      #
      # Then:
      #
      #  response.should have_node(:foo)
      #  response.should have_node(:bar)
      #  response.should have_node(:baz)
      #
      cattr_accessor :response_body_method

      # The default have node matcher that will be used.
      # This have_node matcher is useful when you just work with one content type in your API.
      # Change to :xml if you want that have_node works ONLY with XML.
      # If you work with xml and json in the same API, I recommend that you check the
      # have_json_node and have_xml_node matchers.
      #
      cattr_accessor :have_node_matcher
      self.have_node_matcher = :json
    end
  end
end