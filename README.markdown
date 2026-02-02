# API Matchers [![CI](https://github.com/tomas-stefano/api_matchers/actions/workflows/ci.yml/badge.svg)](https://github.com/tomas-stefano/api_matchers/actions/workflows/ci.yml) [![Gem Version](https://badge.fury.io/rb/api_matchers.svg)](https://badge.fury.io/rb/api_matchers)

Collection of RSpec matchers for your API.

## Table of Contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Matchers](#matchers)
  - [have_json_node](#have_json_node)
  - [have_xml_node](#have_xml_node)
  - [have_node](#have_node)
  - [have_json](#have_json)
  - [match_json_schema](#match_json_schema)
  - [be_json / be_xml](#be_json--be_xml)
- [Configuration](#configuration)
- [Upgrading from 0.x to 1.0](#upgrading-from-0x-to-10)
- [Contributing](#contributing)

## Requirements

- Ruby 3.1+
- RSpec 3.12+

## Installation

Add to your Gemfile:

```ruby
group :test do
  gem 'api_matchers'

  # Optional: for JSON Schema validation
  gem 'json_schemer'
end
```

Or install manually:

```bash
gem install api_matchers
```

## Quick Start

Include the matchers in your RSpec configuration:

```ruby
# spec/spec_helper.rb or spec/rails_helper.rb
RSpec.configure do |config|
  config.include APIMatchers::RSpecMatchers
end
```

Then use them in your specs:

```ruby
RSpec.describe "Users API" do
  it "returns user data" do
    get "/api/users/1"

    expect(response.body).to have_json_node(:id).with(1)
    expect(response.body).to have_json_node(:name).with("John")
    expect(response.body).to have_json_node(:email).including_text("@example.com")
  end
end
```

## Matchers

### have_json_node

Verifies the presence of a node in JSON, with optional value matching.

#### Basic Usage

```ruby
json = '{"user": {"id": 1, "name": "John", "active": true}}'

# Check node exists
expect(json).to have_json_node(:user)
expect(json).to have_json_node(:id)      # Works with nested nodes too

# Check node exists with specific value
expect(json).to have_json_node(:id).with(1)
expect(json).to have_json_node(:name).with("John")
expect(json).to have_json_node(:active).with(true)

# Check node does NOT exist
expect(json).not_to have_json_node(:admin)

# Check node exists but with different value
expect(json).not_to have_json_node(:id).with(999)
```

#### Deeply Nested JSON

```ruby
json = '{
  "response": {
    "data": {
      "transaction": {
        "id": 12345,
        "status": "completed",
        "payment": {
          "method": "credit_card",
          "amount": 99.99
        }
      }
    }
  }
}'

# All these work - it searches recursively
expect(json).to have_json_node(:transaction)
expect(json).to have_json_node(:id).with(12345)
expect(json).to have_json_node(:status).with("completed")
expect(json).to have_json_node(:method).with("credit_card")
expect(json).to have_json_node(:amount).with(99.99)
```

#### Different Value Types

```ruby
# Strings
expect('{"name": "Alice"}').to have_json_node(:name).with("Alice")

# Integers
expect('{"count": 42}').to have_json_node(:count).with(42)

# Floats
expect('{"price": 19.99}').to have_json_node(:price).with(19.99)

# Booleans
expect('{"enabled": true}').to have_json_node(:enabled).with(true)
expect('{"disabled": false}').to have_json_node(:disabled).with(false)

# Null
expect('{"deleted_at": null}').to have_json_node(:deleted_at).with(nil)

# Empty string
expect('{"nickname": ""}').to have_json_node(:nickname).with("")

# Empty array
expect('{"items": []}').to have_json_node(:items).with([])

# Empty object
expect('{"metadata": {}}').to have_json_node(:metadata).with({})
```

#### Partial Text Matching

Use `including_text` to check if a node's value contains specific text:

```ruby
json = '{"error": "Validation failed: Email is invalid, Name is too short"}'

expect(json).to have_json_node(:error).including_text("Email is invalid")
expect(json).to have_json_node(:error).including_text("Validation failed")

# Useful for URLs
json = '{"avatar_url": "https://cdn.example.com/users/123/avatar.png"}'
expect(json).to have_json_node(:avatar_url).including_text("cdn.example.com")
expect(json).to have_json_node(:avatar_url).including_text("/users/123/")

# Useful for timestamps (partial match)
json = '{"created_at": "2024-01-15T10:30:00Z"}'
expect(json).to have_json_node(:created_at).including_text("2024-01-15")

# Useful for generated IDs or tokens
json = '{"session_id": "sess_abc123xyz789"}'
expect(json).to have_json_node(:session_id).including_text("sess_")

# Negation
expect(json).not_to have_json_node(:error).including_text("Server error")
```

#### Array Matching

##### `including` - Check if array contains an element

```ruby
json = '{"users": [{"name": "Alice", "role": "admin"}, {"name": "Bob", "role": "user"}]}'

# Match by single attribute
expect(json).to have_json_node(:users).including(name: "Alice")

# Match by multiple attributes
expect(json).to have_json_node(:users).including(name: "Alice", role: "admin")

# Negation - array does NOT contain element
expect(json).not_to have_json_node(:users).including(name: "Charlie")
expect(json).not_to have_json_node(:users).including(role: "superadmin")

# Works with simple arrays too
json = '{"tags": ["ruby", "rails", "api"]}'
expect(json).to have_json_node(:tags).including("ruby")
expect(json).not_to have_json_node(:tags).including("python")

# Works with numbers
json = '{"scores": [85, 92, 78, 95]}'
expect(json).to have_json_node(:scores).including(92)

# Practical API example - check if a specific item exists in results
json = '{
  "products": [
    {"id": 1, "name": "Laptop", "in_stock": true},
    {"id": 2, "name": "Phone", "in_stock": false},
    {"id": 3, "name": "Tablet", "in_stock": true}
  ]
}'
expect(json).to have_json_node(:products).including(id: 2, name: "Phone")
expect(json).to have_json_node(:products).including(in_stock: true)
```

##### `including_all` - Check if array contains all specified elements

```ruby
json = '{"permissions": [{"action": "read"}, {"action": "write"}, {"action": "delete"}]}'

# All must be present
expect(json).to have_json_node(:permissions).including_all([
  {action: "read"},
  {action: "write"}
])

# Fails if any element is missing
expect(json).not_to have_json_node(:permissions).including_all([
  {action: "read"},
  {action: "execute"}  # This doesn't exist
])

# Simple values
json = '{"ids": [1, 2, 3, 4, 5]}'
expect(json).to have_json_node(:ids).including_all([1, 3, 5])
expect(json).not_to have_json_node(:ids).including_all([1, 6, 7])

# Strings
json = '{"features": ["dark_mode", "notifications", "export", "api_access"]}'
expect(json).to have_json_node(:features).including_all(["dark_mode", "api_access"])

# Practical example - verify required fields in response
json = '{
  "user": {
    "roles": [
      {"name": "viewer", "level": 1},
      {"name": "editor", "level": 2},
      {"name": "admin", "level": 3}
    ]
  }
}'
expect(json).to have_json_node(:roles).including_all([
  {name: "viewer"},
  {name: "admin"}
])

# Verify order doesn't matter
json = '{"steps": ["init", "validate", "process", "complete"]}'
expect(json).to have_json_node(:steps).including_all(["complete", "init"])  # Different order, still passes
```

#### Date and Time Values

The matcher automatically handles Date, DateTime, and Time comparisons:

```ruby
json = '{"created_at": "2024-01-15", "updated_at": "2024-01-15T10:30:00+00:00"}'

expect(json).to have_json_node(:created_at).with(Date.parse("2024-01-15"))
expect(json).to have_json_node(:updated_at).with(DateTime.parse("2024-01-15T10:30:00+00:00"))
```

#### Null Values

```ruby
json = '{"middle_name": null}'

expect(json).to have_json_node(:middle_name)           # Node exists (even if null)
expect(json).to have_json_node(:middle_name).with(nil) # Explicitly check for null
```

### have_xml_node

Same API as `have_json_node`, but for XML:

```ruby
xml = '<user><id>1</id><name>John</name></user>'

expect(xml).to have_xml_node(:id).with("1")
expect(xml).to have_xml_node(:name).with("John")
expect(xml).to have_xml_node(:name).including_text("Jo")
expect(xml).not_to have_xml_node(:email)
```

#### Nested XML

```ruby
xml = '
<response>
  <status>success</status>
  <data>
    <user>
      <id>123</id>
      <profile>
        <first_name>John</first_name>
        <last_name>Doe</last_name>
      </profile>
    </user>
  </data>
</response>
'

expect(xml).to have_xml_node(:status).with("success")
expect(xml).to have_xml_node(:id).with("123")
expect(xml).to have_xml_node(:first_name).with("John")
expect(xml).to have_xml_node(:last_name).with("Doe")
```

#### XML with Attributes

```ruby
xml = '<product id="456" status="active"><name>Widget</name><price currency="USD">29.99</price></product>'

# Check element content
expect(xml).to have_xml_node(:name).with("Widget")
expect(xml).to have_xml_node(:price).with("29.99")

# Check element exists
expect(xml).to have_xml_node(:product)
expect(xml).to have_xml_node(:price)
```

#### Partial Text in XML

```ruby
xml = '<error><message>Validation failed: Email format is invalid</message></error>'

expect(xml).to have_xml_node(:message).including_text("Validation failed")
expect(xml).to have_xml_node(:message).including_text("Email format")
expect(xml).not_to have_xml_node(:message).including_text("Server error")
```

#### SOAP Response Example

```ruby
soap_response = '
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetUserResponse>
      <User>
        <Id>42</Id>
        <Username>johndoe</Username>
        <Email>john@example.com</Email>
      </User>
    </GetUserResponse>
  </soap:Body>
</soap:Envelope>
'

expect(soap_response).to have_xml_node(:Id).with("42")
expect(soap_response).to have_xml_node(:Username).with("johndoe")
expect(soap_response).to have_xml_node(:Email).including_text("@example.com")
```

### have_node

A generic matcher that works with either JSON or XML based on configuration:

```ruby
# Default is JSON
expect('{"name": "John"}').to have_node(:name).with("John")

# Configure for XML
APIMatchers.setup do |config|
  config.have_node_matcher = :xml
end

expect('<name>John</name>').to have_node(:name).with("John")
```

**Tip:** If your API uses both JSON and XML, use `have_json_node` and `have_xml_node` explicitly for clarity.

### have_json

Compare entire JSON structures for exact equality:

```ruby
# Arrays
expect('["foo", "bar", "baz"]').to have_json(["foo", "bar", "baz"])
expect('[1, 2, 3]').to have_json([1, 2, 3])

# Objects
expect('{"a": 1, "b": 2}').to have_json({"a" => 1, "b" => 2})

# Nested structures
expect('{"user": {"name": "John", "age": 30}}').to have_json({
  "user" => {
    "name" => "John",
    "age" => 30
  }
})

# Order matters for arrays
expect('["a", "b", "c"]').to have_json(["a", "b", "c"])
expect('["a", "b", "c"]').not_to have_json(["c", "b", "a"])

# Negation
expect('{"status": "ok"}').not_to have_json({"status" => "error"})

# Useful for API responses with predictable structure
expect(response.body).to have_json({
  "success" => true,
  "data" => []
})
```

### match_json_schema

Validate JSON against a [JSON Schema](https://json-schema.org/). Requires the `json_schemer` gem.

#### Basic Usage

```ruby
schema = {
  type: "object",
  required: ["id", "name"],
  properties: {
    id: { type: "integer" },
    name: { type: "string", minLength: 1 },
    email: { type: "string", format: "email" }
  }
}

# Valid JSON
expect('{"id": 1, "name": "John"}').to match_json_schema(schema)

# Invalid JSON - missing required field
expect('{"id": 1}').not_to match_json_schema(schema)

# Invalid JSON - wrong type
expect('{"id": "not-an-integer", "name": "John"}').not_to match_json_schema(schema)
```

#### Complex Schemas

```ruby
schema = {
  type: "object",
  required: ["data"],
  properties: {
    data: {
      type: "array",
      items: {
        type: "object",
        required: ["id", "type"],
        properties: {
          id: { type: "integer" },
          type: { type: "string", enum: ["user", "admin"] },
          attributes: {
            type: "object",
            properties: {
              name: { type: "string" },
              created_at: { type: "string", format: "date-time" }
            }
          }
        }
      }
    },
    meta: {
      type: "object",
      properties: {
        total: { type: "integer" },
        page: { type: "integer" }
      }
    }
  }
}

json = {
  data: [
    { id: 1, type: "user", attributes: { name: "John" } },
    { id: 2, type: "admin", attributes: { name: "Jane" } }
  ],
  meta: { total: 2, page: 1 }
}.to_json

expect(json).to match_json_schema(schema)
```

#### Schema as JSON String

```ruby
schema_json = '{"type": "object", "required": ["id"]}'
expect('{"id": 1}').to match_json_schema(schema_json)
```

#### Array Validation

```ruby
# Array of specific type
schema = {
  type: "object",
  properties: {
    tags: {
      type: "array",
      items: { type: "string" },
      minItems: 1,
      uniqueItems: true
    }
  }
}

expect('{"tags": ["ruby", "rails"]}').to match_json_schema(schema)
expect('{"tags": []}').not_to match_json_schema(schema)  # minItems: 1
expect('{"tags": ["ruby", "ruby"]}').not_to match_json_schema(schema)  # uniqueItems

# Array with mixed object types
schema = {
  type: "array",
  items: {
    type: "object",
    required: ["type"],
    properties: {
      type: { type: "string", enum: ["text", "image", "video"] },
      url: { type: "string", format: "uri" }
    }
  }
}

json = '[{"type": "text"}, {"type": "image", "url": "https://example.com/img.png"}]'
expect(json).to match_json_schema(schema)
```

#### String Formats

```ruby
schema = {
  type: "object",
  properties: {
    email: { type: "string", format: "email" },
    website: { type: "string", format: "uri" },
    uuid: { type: "string", format: "uuid" },
    date: { type: "string", format: "date" },
    datetime: { type: "string", format: "date-time" },
    ipv4: { type: "string", format: "ipv4" }
  }
}

json = '{
  "email": "user@example.com",
  "website": "https://example.com",
  "uuid": "550e8400-e29b-41d4-a716-446655440000",
  "date": "2024-01-15",
  "datetime": "2024-01-15T10:30:00Z",
  "ipv4": "192.168.1.1"
}'
expect(json).to match_json_schema(schema)
```

#### Numeric Constraints

```ruby
schema = {
  type: "object",
  properties: {
    age: { type: "integer", minimum: 0, maximum: 150 },
    price: { type: "number", minimum: 0, exclusiveMinimum: true },
    quantity: { type: "integer", multipleOf: 5 },
    rating: { type: "number", minimum: 1, maximum: 5 }
  }
}

expect('{"age": 25, "price": 9.99, "quantity": 10, "rating": 4.5}').to match_json_schema(schema)
expect('{"age": -1}').not_to match_json_schema(schema)  # minimum: 0
expect('{"price": 0}').not_to match_json_schema(schema)  # exclusiveMinimum
```

#### Conditional Validation

```ruby
schema = {
  type: "object",
  properties: {
    type: { type: "string", enum: ["personal", "business"] },
    company_name: { type: "string" }
  },
  if: {
    properties: { type: { const: "business" } }
  },
  then: {
    required: ["company_name"]
  }
}

expect('{"type": "personal"}').to match_json_schema(schema)
expect('{"type": "business", "company_name": "Acme Inc"}').to match_json_schema(schema)
expect('{"type": "business"}').not_to match_json_schema(schema)  # missing company_name
```

#### Pattern Matching

```ruby
schema = {
  type: "object",
  properties: {
    phone: { type: "string", pattern: "^\\+?[1-9]\\d{1,14}$" },
    slug: { type: "string", pattern: "^[a-z0-9-]+$" },
    hex_color: { type: "string", pattern: "^#[0-9A-Fa-f]{6}$" }
  }
}

expect('{"phone": "+14155551234", "slug": "my-post", "hex_color": "#FF5733"}').to match_json_schema(schema)
```

#### Error Messages

When validation fails, you get detailed error messages:

```
Expected JSON to match schema.
Errors:
  - value at `/name` is not a string at name
  - object at root is missing required properties: email

Response: {"id":1,"name":123}
```

### be_json / be_xml

Check the Content-Type header:

```ruby
# Direct header value
expect("application/json; charset=utf-8").to be_json
expect("application/xml; charset=utf-8").to be_xml

# From response object
expect(response.headers['Content-Type']).to be_json
expect(response.headers['Content-Type']).to be_xml

# Negation
expect(response.headers['Content-Type']).not_to be_xml  # when it's JSON
expect(response.headers['Content-Type']).not_to be_json  # when it's XML

# Aliases available
expect(response.headers['Content-Type']).to be_in_json
expect(response.headers['Content-Type']).to be_in_xml
expect(response.headers['Content-Type']).to be_a_json

# With configuration (see Configuration section), use response directly
expect(response).to be_json
expect(response).to be_xml
```

#### Practical Examples

```ruby
RSpec.describe "API Content Types", type: :request do
  it "returns JSON for user endpoint" do
    get "/api/users/1"

    expect(response.headers['Content-Type']).to be_json
  end

  it "returns XML for legacy endpoint" do
    get "/api/legacy/users/1"

    expect(response.headers['Content-Type']).to be_xml
  end

  it "returns JSON by default" do
    get "/api/data"

    expect(response.headers['Content-Type']).to be_json
    expect(response.headers['Content-Type']).not_to be_xml
  end
end
```

## Configuration

Configure APIMatchers to work seamlessly with your test setup:

```ruby
# spec/spec_helper.rb or spec/support/api_matchers.rb
APIMatchers.setup do |config|
  # Automatically extract body from response objects
  config.response_body_method = :body

  # Configure header access for be_json/be_xml matchers
  config.header_method = :headers
  config.header_content_type_key = 'Content-Type'

  # Set default format for have_node matcher (:json or :xml)
  config.have_node_matcher = :json
end
```

### With Rails

```ruby
APIMatchers.setup do |config|
  config.response_body_method = :body
  config.header_method = :headers
  config.header_content_type_key = 'Content-Type'
end

# Now you can use response directly:
RSpec.describe "API", type: :request do
  it "returns JSON" do
    get "/api/users/1"

    expect(response).to have_json_node(:id).with(1)
    expect(response).to be_json
  end
end
```

### With HTTP Clients (HTTParty, Faraday, etc.)

```ruby
APIMatchers.setup do |config|
  config.response_body_method = :body
  config.header_method = :headers
  config.header_content_type_key = 'content-type'  # Note: lowercase for some clients
end
```

## Upgrading from 0.x to 1.0

### Breaking Changes

1. **Ruby 3.1+ required** - Ruby 1.9, 2.x, and early 3.x versions are no longer supported.

2. **HTTP Status Matchers Removed** - These matchers have been removed as they duplicate `rspec-rails` functionality:

   | Removed Matcher | rspec-rails Equivalent |
   |----------------|----------------------|
   | `be_ok` | `have_http_status(:ok)` |
   | `create_resource` | `have_http_status(:created)` |
   | `be_bad_request` | `have_http_status(:bad_request)` |
   | `be_unauthorized` | `have_http_status(:unauthorized)` |
   | `be_forbidden` | `have_http_status(:forbidden)` |
   | `be_not_found` | `have_http_status(:not_found)` |
   | `be_unprocessable_entity` | `have_http_status(:unprocessable_entity)` |
   | `be_internal_server_error` | `have_http_status(:internal_server_error)` |

   **Migration example:**
   ```ruby
   # Before (api_matchers 0.x)
   expect(response.status).to be_ok
   expect(response.status).to create_resource

   # After (rspec-rails)
   expect(response).to have_http_status(:ok)
   expect(response).to have_http_status(:created)
   ```

3. **Configuration Changes** - The `http_status_method` configuration option has been removed.

### New Features in 1.0

- **`including(attributes)`** - Check if a JSON array contains an element matching the given attributes
- **`including_all(elements)`** - Check if a JSON array contains all specified elements
- **`match_json_schema(schema)`** - Validate JSON against a JSON Schema (requires `json_schemer` gem)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Acknowledgements

* Special thanks to Daniel Konishi for contributing to the product from which I extracted the matchers for this gem.

## Contributors

* Stephen Orens
* Lucas Caton

## License

MIT License. See [LICENSE](LICENSE) for details.
