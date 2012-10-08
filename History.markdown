## v0.1.1

1) Support Datetime, Date and Time comparison (Thanks to Stephen Orens).
2) The have_node should accept boolean values (Thanks to Stephen Orens).

## v0.1.0

1) Add the #including_text for have_json_node and have_xml_node matcher:

    { :error => "Transaction error: Name can't be blank" }.to_json.should have_json_node(:error).including_text("Transaction error")

    "<error>Transaction error: Name can't be blank</error>".should have_xml_node(:error).including_text("Transaction error")

## v0.0.2

1) Put the headers method and the content type key in the setup class and that will be used by the headers matchers(be_json and be_xml).

This:

    response.headers['Content-Type'].should be_in_json
    response.headers['Content-Type'].should be_in_xml

With:

    APIMatchers.setup do |config|
      config.header_method           = :headers
      config.header_content_type_key = 'Content-Type'
    end

Becomes:

    response.should be_in_json
    response.should be_in_xml

## v0.0.1

1) Headers Matchers: be_xml, be_json (**OBS:** Need to think about the setup!)
2) HTTP Status Matchers: be_a_bad_request, be_internal_server_error, be_unauthorized, create_resource
3) Response body Matchers: have_node, have_json_node, have_xml_node
