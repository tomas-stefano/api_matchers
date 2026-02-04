# History

## 1.0.0 (2026-02-04)

### Major Release - Comprehensive API Testing Suite

This release transforms API Matchers into a complete API testing toolkit with 30+ new matchers.

#### New Features

**HTTP Status Matchers**
- `have_http_status(status)` - Match by code or symbol
- `be_successful` - Match 2xx responses
- `be_redirect` - Match 3xx responses
- `be_client_error` - Match 4xx responses
- `be_server_error` - Match 5xx responses
- `be_not_found` - Match 404
- `be_unauthorized` - Match 401
- `be_forbidden` - Match 403
- `be_unprocessable` - Match 422
- `be_no_content` - Match 204

**JSON Structure Matchers**
- `have_json_keys(*keys)` - Verify key presence
- `have_json_type(type)` - Check value types

**Collection Matchers**
- `have_json_size(size)` - Verify collection sizes
- `be_sorted_by(field)` - Check sorting with `.ascending`/`.descending`

**Header Matchers**
- `have_header(name)` - Check headers with `.with_value`
- `have_cors_headers` - Verify CORS compliance
- `have_cache_control(*directives)` - Check cache directives

**Pagination Matchers**
- `be_paginated` - Check pagination metadata
- `have_pagination_links(*types)` - Verify link types
- `have_total_count(count)` - Match total counts

**Error Response Matchers**
- `have_error` / `have_errors` - Check error presence
- `have_error_on(field)` - Field-specific errors with `.with_message`

**JSON:API Matchers**
- `be_json_api_compliant` - Validate spec compliance
- `have_json_api_data` - Check data with `.of_type`/`.with_id`
- `have_json_api_attributes(*attrs)` - Verify attributes
- `have_json_api_relationships(*rels)` - Check relationships

**HATEOAS Matchers**
- `have_link(rel)` - Match HAL-style links with `.with_href`

#### Improvements
- Added Ruby 3.4 support
- Modernized codebase with `frozen_string_literal` pragmas
- Simplified internal setup pattern
- Enhanced error messages across all matchers
- Comprehensive README documentation with examples

#### Breaking Changes
- Minimum Ruby version is now 3.1
- Removed deprecated configuration options

---

## 0.6.0

- Added `have_json` matcher for exact JSON matching
- Added `match_json_schema` matcher for JSON Schema validation
- Improved `have_json_node` with better nested path support

## 0.5.0

- Added support for RSpec 3
- Added `have_xml_node` matcher
- Improved error messages

## 0.4.0

- Initial configurable setup
- Added `be_json` and `be_xml` content type matchers
- Added `have_node` matcher with format detection
