# TODO

## Future Improvements

### New Matchers
- [ ] `include_json` - Deep partial JSON matching for flexible assertions
- [ ] `have_json_path` - Verify a JSON path exists without checking value
- [ ] `match_json_pattern` - Pattern-based JSON matching with wildcards
- [ ] `be_valid_uuid` - Validate UUID format in responses
- [ ] `be_valid_iso8601` - Validate ISO 8601 date/time formats
- [ ] `have_etag` - Check for ETag header presence and format
- [ ] `be_gzip_encoded` - Verify response compression

### Enhancements
- [ ] Add `at_index` chain for collection matchers (e.g., `have_json_keys(:id).at_index(0)`)
- [ ] Support JSONPath syntax as alternative to dot-notation paths
- [ ] Add `including` chain for partial key matching
- [ ] Support regex patterns in `with_value` and `with_href` chains
- [ ] Add `within` tolerance for numeric comparisons

### Configuration
- [ ] Add configurable JSON parser (support Oj, Yajl as alternatives)
- [ ] Add configurable date/time parsing for sorting comparisons
- [ ] Support custom error message formatters

### Documentation
- [ ] Add YARD documentation for all public methods
- [ ] Create a cookbook with real-world API testing examples
- [ ] Add migration guide from other API testing libraries

### Performance
- [ ] Lazy JSON parsing - only parse when needed
- [ ] Cache parsed JSON across chained matchers
- [ ] Benchmark suite for performance regression testing

### Compatibility
- [ ] Minitest adapter for non-RSpec users
- [ ] Integration examples with popular HTTP clients (Faraday, HTTParty, RestClient)
- [ ] Rails system test integration guide
