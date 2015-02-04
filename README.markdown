# API Matchers [![Build Status](https://travis-ci.org/tomas-stefano/api_matchers.png?branch=master)](https://travis-ci.org/tomas-stefano/api_matchers)

Collection of RSpec matchers for your API.

## Response Body Matchers

* `have_node`
* `have_json_node`
* `have_xml_node`
* `have_json`

## Response Status Matchers

* `be_ok`
* `create_resource`
* `be_a_bad_request`
* `be_unauthorized`
* `be_forbidden`
* `be_internal_server_error`
* `be_not_found`

## Other Matchers

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
expect('{ "transaction": { "id": 54, "status": "paid" } }').to have_node(:transaction)
```

Or if node exist with a value:

```ruby
expect('{ "transaction": { "id": 54, "status": "paid" } }').to have_node(:id).with(54)
```

```ruby
expect('{ "error": "not_authorized" }').to have_node(:error).with('not_authorized')
```

```ruby
expect('{"parcels":1 }').to have_node(:parcels).with(1)
```

To see the json node and see if include a text, you can do this:

```ruby
expect('{"error": "Transaction error: Name cant be blank"}').to have_node(:error).including_text("Transaction error")
```

You can verify boolean values too:

```ruby
expect('{"creditcard":true}').to have_node(:creditcard).with(true)
```

### HAVE NODE Matcher Configuration

You can configure if you want xml (JSON is the default):

```ruby
APIMatchers.setup do |config|
  config.content_type = :xml
end
```

```ruby
expect('<transaction><id>200</id><status>paid</status></transaction>').to have_node(:status)
```

Using the `with` method:

```ruby
expect('<transaction><id>200</id><status>paid</status></transaction>').to have_node(:status).with('paid')
```

Or you can use the `have_xml_node` matcher:

```ruby
expect("<error>Transaction error: Name can't be blank</error>").to have_xml_node(:error).with("Transaction error: Name can't be blank")
```

To see the xml node and see if include a text, you can do this:

```ruby
expect("<error>Transaction error: Name can't be blank</error>").to have_xml_node(:error).including_text("Transaction error")
```

**If you work with xml and json in the same API, check the have_json_node and have_xml_node matchers.**

You can configure the name of the method and then you will be able to use *without* the **#body** method, for example:

```ruby
APIMatchers.setup do |config|
  config.response_body_method = :body
end

expect(response).to have_node(:foo).with('bar')
```

Instead of:

```ruby
expect(response.body).to have_node(:foo)
```

### Have JSON Node Matcher

```ruby
expect('{ "transaction": { "id": 54, "status": "paid" } }').to have_json_node(:id).with(54)
```

### Have XML Node Matcher

```ruby
expect("<product><name>gateway</name></product>").to have_xml_node(:name).with('gateway')
```

### Have JSON Matcher

Sometimes, you want to compare the entire JSON structure:

```ruby
expect("['Foo', 'Bar', 'Baz']").to have_json(['Foo', 'Bar', 'Baz'])
```

### Create Resource Matcher

This matchers see the HTTP STATUS CODE is equal to 201.

```ruby
expect(response.status).to create_resource
```

### BAD REQUEST Matcher

This BAD REQUEST is a matcher that see if the HTTP STATUS code is equal to 400.

```ruby
expect(response.status).to be_a_bad_request
expect(response.status).to be_bad_request
```

### UNAUTHORIZED Matcher

This UNAUTHORIZED is a matcher that see if the HTTP STATUS code is equal to 401.

```ruby
expect(response.status).to be_unauthorized
expect(response.body).to have_node(:message).with('Invalid Credentials')
```

### FORBIDDEN Matcher

This is a matcher to see if the HTTP STATUS code is equal to 403.

```ruby
expect(response.status).to be_forbidden
```

### INTERNAL SERVER ERROR Matcher

This INTERNAL SERVER Error is a matcher that see if the HTTP STATUS code is equal to 500.

```ruby
expect(response.status).to be_internal_server_error
expect(response.body).to have_node(:message).with('An Internal Error Occurs in our precious app. :S')
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
expect(response).to create_resource
```

This configurations affects this matchers:

* `be_ok`
* `create_resource`
* `be_a_bad_request`
* `be_internal_server_error`
* `be_unauthorized`
* `be_forbidden`
* `be_not_found`

### Be in XML Matcher

This is a matcher that see if the content type is xml:

```ruby
expect(response.headers['Content-Type']).to be_in_xml
```

### Be in JSON Matcher

This is a matcher that see if the content type is in JSON:

```ruby
expect(response.headers['Content-Type']).to be_in_json
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
expect(response).to be_in_json
expect(response).to be_in_xml
```

### Acknowlegments

* Special thanks to Daniel Konishi to contribute in the product that I extracted the matchers to this gem.

### Contributors

* Stephen Orens
* Lucas Caton
