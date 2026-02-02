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

#### Partial Text Matching

Use `including_text` to check if a node's value contains specific text:

```ruby
json = '{"error": "Validation failed: Email is invalid, Name is too short"}'

expect(json).to have_json_node(:error).including_text("Email is invalid")
expect(json).to have_json_node(:error).including_text("Validation failed")
```

#### Array Matching

##### `including` - Check if array contains an element

```ruby
json = '{"users": [{"name": "Alice", "role": "admin"}, {"name": "Bob", "role": "user"}]}'

# Match by single attribute
expect(json).to have_json_node(:users).including(name: "Alice")

# Match by multiple attributes
expect(json).to have_json_node(:users).including(name: "Alice", role: "admin")

# Works with simple arrays too
json = '{"tags": ["ruby", "rails", "api"]}'
expect(json).to have_json_node(:tags).including("ruby")
```

##### `including_all` - Check if array contains all specified elements

```ruby
json = '{"permissions": [{"action": "read"}, {"action": "write"}, {"action": "delete"}]}'

# All must be present
expect(json).to have_json_node(:permissions).including_all([
  {action: "read"},
  {action: "write"}
])

# Simple values
json = '{"ids": [1, 2, 3, 4, 5]}'
expect(json).to have_json_node(:ids).including_all([1, 3, 5])
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

Compare entire JSON structures:

```ruby
expect('["foo", "bar", "baz"]').to have_json(["foo", "bar", "baz"])
expect('{"a": 1, "b": 2}').to have_json({"a" => 1, "b" => 2})
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
expect(response.headers['Content-Type']).to be_json
expect(response.headers['Content-Type']).to be_xml

# Aliases
expect(response.headers['Content-Type']).to be_in_json
expect(response.headers['Content-Type']).to be_in_xml
expect(response.headers['Content-Type']).to be_a_json
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
