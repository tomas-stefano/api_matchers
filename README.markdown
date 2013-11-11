# API Matchers [![Build Status](https://travis-ci.org/tomas-stefano/api_matchers.png?branch=master)](https://travis-ci.org/tomas-stefano/api_matchers)

Collection of RSpec matchers for your API.

## Response Body Matchers

* `have_node`
* `have_json_node`
* `have_xml_node`

# Response Status Matchers

* `be_ok`
* `create_resource`
* `be_a_bad_request`
* `be_unauthorized`
* `be_internal_server_error`
* `be_not_found`

# Other Matchers

* `be_in_xml`
* `be_in_json`

## Install

Include the gem to your test group in you Gemfile:

```ruby
group :test do
  gem 'api_matchers'
  # other gems
end
```

Or install it manually: `gem install api_matchers`.

## Usage

### Including in RSpec

To include all this matchers you need to include the APIMatchers::RSpecMatchers module:

```ruby
RSpec.configure do |config|
  config.include APIMatchers::RSpecMatchers
end
```

### Have Node Matcher

The have_node matcher parse the actual and see if have the expcted node with the expected value.
**The default that have_node will parse is JSON.**

You can verify if node exists:

```ruby
'{ "transaction": { "id": 54, "status": "paid" } }'.should have_node(:transaction)
```

Or if node exist with a value:

```ruby
'{ "transaction": { "id": 54, "status": "paid" } }'.should have_node(:id).with(54)
```

```ruby
'{ "error": "not_authorized" }'.should have_node(:error).with('not_authorized')
```

```ruby
'{"parcels":1 }'.should have_node(:parcels).with(1)
```

To see the json node and see if include a text, you can do this:

```ruby
'{"error": "Transaction error: Name cant be blank"}'.should have_node(:error).including_text("Transaction error")
```

You can verify boolean values too:

```ruby
'{"creditcard":true}'.should have_node(:creditcard).with(true)
```

### HAVE NODE Matcher Configuration

You can configure if you want xml (JSON is the default):

```ruby
APIMatchers.setup do |config|
  config.content_type = :xml
end
```

```ruby
'<transaction><id>200</id><status>paid</status></transaction>'.should have_node(:status)
```

Using the `with` method:

```ruby
'<transaction><id>200</id><status>paid</status></transaction>'.should have_node(:status).with('paid')
```

Or you can use the `have_xml_node` matcher:

```ruby
"<error>Transaction error: Name can't be blank</error>".should have_xml_node(:error).with("Transaction error: Name can't be blank")
```

To see the xml node and see if include a text, you can do this:

```ruby
"<error>Transaction error: Name can't be blank</error>".should have_xml_node(:error).including_text("Transaction error")
```

**If you work with xml and json in the same API, check the have_json_node and have_xml_node matchers.**

You can configure the name of the method and then you will be able to use *without* the **#body** method, for example:

```ruby
APIMatchers.setup do |config|
  config.response_body_method = :body
end

response.should have_node(:foo).with('bar')
```

# Instead of:
response.body.should have_node(:foo)
```

### Have JSON Node Matcher

```ruby
'{ "transaction": { "id": 54, "status": "paid" } }'.should have_json_node(:id).with(54)
```

### Have XML Node Matcher

```ruby
"<product><name>gateway</name></product>".should have_xml_node(:name).with('gateway')
```

### Create Resource Matcher

This matchers see the HTTP STATUS CODE is equal to 201.

```ruby
response.status.should create_resource
```

### BAD REQUEST Matcher

This BAD REQUEST is a matcher that see if the HTTP STATUS code is equal to 400.

```ruby
response.status.should be_a_bad_request
response.status.should be_bad_request
```

### UNAUTHORIZED Matcher

This UNAUTHORIZED is a matcher that see if the HTTP STATUS code is equal to 401.

```ruby
response.status.should be_unauthorized
response.body.should have_node(:message).with('Invalid Credentials')
```

### INTERNAL SERVER ERROR Matcher

This INTERNAL SERVER Error is a matcher that see if the HTTP STATUS code is equal to 500.

```ruby
response.status.should be_internal_server_error
response.body.should have_node(:message).with('An Internal Error Occurs in our precious app. :S')
```

### HTTP STATUS CODE Configuration

You can configure the name method to call the http status code:

```ruby
APIMatchers.setup do |config|
  config.http_status_method = :status
end
```

Then you can use without call the **#status** method:

```ruby
response.should create_resource
```

This configurations affects this matchers:

* `be_ok`
* `create_resource`
* `be_a_bad_request`
* `be_internal_server_error`
* `be_unauthorized`
* `be_not_found`

### Be in XML Matcher

This is a matcher that see if the content type is xml:

```ruby
response.headers['Content-Type'].should be_in_xml
```

### Be in JSON Matcher

This is a matcher that see if the content type is in JSON:

```ruby
response.headers['Content-Type'].should be_in_json
```

### Headers Configuration

You can configure the name method to call the headers and content type:

```ruby
APIMatchers.setup do |config|
  config.header_method           = :headers
  config.header_content_type_key = 'Content-Type'
end
```

And then you will be able to use without call the **#headers** calling the **#['Content-Type']** method:

```ruby
response.should be_in_json
response.should be_in_xml
```

### Acknowlegments

* Special thanks to Daniel Konishi to contribute in the product that I extracted the matchers to this gem.

### Contributors

* Stephen Orens
* Lucas Caton
