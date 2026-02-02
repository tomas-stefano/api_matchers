# API Matchers [![CI](https://github.com/tomas-stefano/api_matchers/actions/workflows/ci.yml/badge.svg)](https://github.com/tomas-stefano/api_matchers/actions/workflows/ci.yml)

Collection of RSpec matchers for your API.

## Requirements

- Ruby 3.1+
- RSpec 3.12+

## Response Body Matchers

* `have_node`
* `have_json_node`
* `have_xml_node`
* `have_json`
* `match_json_schema` (requires `json_schemer` gem)

## Content Type Matchers

* `be_in_xml`
* `be_in_json`

## Install

Include the gem to your test group in your Gemfile:

```ruby
group :test do
  gem 'api_matchers'
  # For JSON schema validation (optional)
  gem 'json_schemer'
end
```

Or install it manually: `gem install api_matchers`.

## Usage

### Including in RSpec

To include all matchers you need to include the APIMatchers::RSpecMatchers module:

```ruby
RSpec.configure do |config|
  config.include APIMatchers::RSpecMatchers
end
```

### Have Node Matcher

The have_node matcher parses the actual value and checks if it has the expected node with the expected value.
**The default format that have_node will parse is JSON.**

You can verify if a node exists:

```ruby
expect('{ "transaction": { "id": 54, "status": "paid" } }').to have_node(:transaction)
```

Or if a node exists with a specific value:

```ruby
expect('{ "transaction": { "id": 54, "status": "paid" } }').to have_node(:id).with(54)
```

```ruby
expect('{ "error": "not_authorized" }').to have_node(:error).with('not_authorized')
```

```ruby
expect('{"parcels":1 }').to have_node(:parcels).with(1)
```

To check if a json node includes specific text:

```ruby
expect('{"error": "Transaction error: Name cant be blank"}').to have_node(:error).including_text("Transaction error")
```

You can verify boolean values too:

```ruby
expect('{"creditcard":true}').to have_node(:creditcard).with(true)
```

### Have Node Matcher Configuration

You can configure if you want XML (JSON is the default):

```ruby
APIMatchers.setup do |config|
  config.have_node_matcher = :xml
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
expect(
  "<error>Transaction error: Name can't be blank</error>"
).to have_xml_node(:error).with("Transaction error: Name can't be blank")
```

To see the xml node and see if it includes specific text:

```ruby
expect(
  "<error>Transaction error: Name can't be blank</error>"
).to have_xml_node(:error).including_text("Transaction error")
```

**If you work with xml and json in the same API, check the have_json_node and have_xml_node matchers.**

You can configure the name of the method so you can use it *without* the **#body** method:

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
expect(
  '{ "transaction": { "id": 54, "status": "paid" } }'
).to have_json_node(:id).with(54)
```

#### Array Inclusion

Check if an array contains elements matching specific criteria:

```ruby
# Check if array includes an element with matching attributes
expect('{"users": [{"name": "Alice"}, {"name": "Bob"}]}').to have_json_node(:users).including(name: "Alice")

# Check if array includes all specified elements
expect('{"items": [{"id": 1}, {"id": 2}, {"id": 3}]}').to have_json_node(:items).including_all([{id: 1}, {id: 2}])
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

### Match JSON Schema Matcher

Validate JSON against a JSON Schema (requires `json_schemer` gem):

```ruby
schema = {
  type: "object",
  required: ["id", "name"],
  properties: {
    id: { type: "integer" },
    name: { type: "string" },
    email: { type: "string", format: "email" }
  }
}

expect('{"id": 1, "name": "John", "email": "john@example.com"}').to match_json_schema(schema)
```

### Be in XML Matcher

Check if the content type is XML:

```ruby
expect(response.headers['Content-Type']).to be_in_xml
```

### Be in JSON Matcher

Check if the content type is JSON:

```ruby
expect(response.headers['Content-Type']).to be_in_json
```

### Headers Configuration

You can configure the header method and content type key:

```ruby
APIMatchers.setup do |config|
  config.header_method           = :headers
  config.header_content_type_key = 'Content-Type'
end
```

And then you can use without calling the **#headers** method:

```ruby
expect(response).to be_in_json
expect(response).to be_in_xml
```

## Upgrading from 0.x to 1.0

### Breaking Changes

1. **Ruby 3.1+ required** - Ruby 1.9, 2.x, and early 3.x versions are no longer supported.

2. **HTTP Status Matchers Removed** - The following matchers have been removed as they overlap with `rspec-rails`:
   - `be_ok`
   - `create_resource`
   - `be_a_bad_request` / `be_bad_request`
   - `be_unauthorized`
   - `be_forbidden`
   - `be_internal_server_error`
   - `be_not_found`
   - `be_unprocessable_entity`

   **Migration**: Use `rspec-rails` matchers instead:
   ```ruby
   # Before
   expect(response.status).to be_ok
   expect(response.status).to create_resource

   # After (with rspec-rails)
   expect(response).to have_http_status(:ok)
   expect(response).to have_http_status(:created)
   ```

3. **Configuration Changes** - `http_status_method` configuration option has been removed.

### New Features

- `including` and `including_all` methods for array matching in `have_json_node`
- `match_json_schema` matcher for JSON Schema validation (requires `json_schemer` gem)

## Acknowledgements

* Special thanks to Daniel Konishi for contributing to the product from which I extracted the matchers for this gem.

## Contributors

* Stephen Orens
* Lucas Caton
