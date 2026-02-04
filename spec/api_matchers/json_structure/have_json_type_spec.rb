require 'spec_helper'

RSpec.describe APIMatchers::JsonStructure::HaveJsonType do
  describe "actual.to have_json_type" do
    context "Integer type" do
      it "passes for integer value" do
        json = '{"id": 42}'
        expect(json).to have_json_type(Integer).at_path("id")
      end

      it "fails for non-integer value" do
        json = '{"id": "42"}'
        expect {
          expect(json).to have_json_type(Integer).at_path("id")
        }.to fail_with(/expected JSON value at 'id' to be of type Integer/)
      end
    end

    context "String type" do
      it "passes for string value" do
        json = '{"name": "John"}'
        expect(json).to have_json_type(String).at_path("name")
      end

      it "fails for non-string value" do
        json = '{"name": 123}'
        expect {
          expect(json).to have_json_type(String).at_path("name")
        }.to fail_with(/expected JSON value at 'name' to be of type String/)
      end
    end

    context "Boolean type" do
      it "passes for true value" do
        json = '{"active": true}'
        expect(json).to have_json_type(:boolean).at_path("active")
      end

      it "passes for false value" do
        json = '{"active": false}'
        expect(json).to have_json_type(:boolean).at_path("active")
      end

      it "fails for non-boolean value" do
        json = '{"active": "true"}'
        expect {
          expect(json).to have_json_type(:boolean).at_path("active")
        }.to fail_with(/expected JSON value at 'active' to be of type Boolean/)
      end
    end

    context "Array type" do
      it "passes for array value" do
        json = '{"items": [1, 2, 3]}'
        expect(json).to have_json_type(Array).at_path("items")
      end

      it "fails for non-array value" do
        json = '{"items": "not an array"}'
        expect {
          expect(json).to have_json_type(Array).at_path("items")
        }.to fail_with(/expected JSON value at 'items' to be of type Array/)
      end
    end

    context "Hash type" do
      it "passes for hash/object value" do
        json = '{"user": {"name": "John"}}'
        expect(json).to have_json_type(Hash).at_path("user")
      end

      it "fails for non-hash value" do
        json = '{"user": "not a hash"}'
        expect {
          expect(json).to have_json_type(Hash).at_path("user")
        }.to fail_with(/expected JSON value at 'user' to be of type Hash/)
      end
    end

    context "NilClass type" do
      it "passes for null value" do
        json = '{"value": null}'
        expect(json).to have_json_type(NilClass).at_path("value")
      end

      it "fails for non-null value" do
        json = '{"value": "something"}'
        expect {
          expect(json).to have_json_type(NilClass).at_path("value")
        }.to fail_with(/expected JSON value at 'value' to be of type NilClass/)
      end
    end

    context "Numeric type" do
      it "passes for integer value" do
        json = '{"count": 42}'
        expect(json).to have_json_type(Numeric).at_path("count")
      end

      it "passes for float value" do
        json = '{"price": 19.99}'
        expect(json).to have_json_type(Numeric).at_path("price")
      end
    end

    context "nested path" do
      it "navigates nested structure" do
        json = '{"user": {"profile": {"age": 30}}}'
        expect(json).to have_json_type(Integer).at_path("user.profile.age")
      end
    end

    context "at root" do
      it "checks type at root level without at_path" do
        json = '[1, 2, 3]'
        expect(json).to have_json_type(Array)
      end
    end
  end

  describe "actual.not_to have_json_type" do
    it "passes when type does not match" do
      json = '{"id": "42"}'
      expect(json).not_to have_json_type(Integer).at_path("id")
    end

    it "fails when type matches" do
      json = '{"id": 42}'
      expect {
        expect(json).not_to have_json_type(Integer).at_path("id")
      }.to fail_with(/expected JSON value at 'id' NOT to be of type Integer/)
    end
  end
end
