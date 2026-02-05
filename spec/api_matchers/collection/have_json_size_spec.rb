require 'spec_helper'

RSpec.describe APIMatchers::Collection::HaveJsonSize do
  describe "actual.to have_json_size" do
    context "with array at root" do
      it "passes when size matches" do
        json = '[1, 2, 3]'
        expect(json).to have_json_size(3)
      end

      it "fails when size does not match" do
        json = '[1, 2, 3]'
        expect {
          expect(json).to have_json_size(5)
        }.to fail_with(/expected JSON collection at 'root' to have size 5. Got size: 3/)
      end
    end

    context "with array at path" do
      it "passes when size matches" do
        json = '{"users": [{"id": 1}, {"id": 2}, {"id": 3}]}'
        expect(json).to have_json_size(3).at_path("users")
      end

      it "fails when size does not match" do
        json = '{"users": [{"id": 1}, {"id": 2}]}'
        expect {
          expect(json).to have_json_size(5).at_path("users")
        }.to fail_with(/expected JSON collection at 'users' to have size 5. Got size: 2/)
      end
    end

    context "with empty array" do
      it "passes for size 0" do
        json = '{"items": []}'
        expect(json).to have_json_size(0).at_path("items")
      end

      it "fails when expecting non-zero size" do
        json = '{"items": []}'
        expect {
          expect(json).to have_json_size(5).at_path("items")
        }.to fail_with(/Got size: 0/)
      end
    end

    context "with hash (keys count)" do
      it "checks size of hash keys" do
        json = '{"a": 1, "b": 2, "c": 3}'
        expect(json).to have_json_size(3)
      end
    end

    context "when path does not exist" do
      it "fails with descriptive message" do
        json = '{"data": []}'
        expect {
          expect(json).to have_json_size(5).at_path("users")
        }.to fail_with(/but path was not found/)
      end
    end

    context "when value is not a collection" do
      it "fails with descriptive message" do
        json = '{"count": "not a collection"}'
        expect {
          expect(json).to have_json_size(5).at_path("count")
        }.to fail_with(/path was not found or value was not a collection/)
      end
    end
  end

  describe "actual.not_to have_json_size" do
    it "passes when size does not match" do
      json = '[1, 2, 3]'
      expect(json).not_to have_json_size(5)
    end

    it "fails when size matches" do
      json = '[1, 2, 3]'
      expect {
        expect(json).not_to have_json_size(3)
      }.to fail_with(/expected JSON collection at 'root' NOT to have size 3/)
    end
  end

  describe "with configuration" do
    before do
      APIMatchers.setup { |config| config.response_body_method = :body }
    end

    after do
      APIMatchers.setup { |config| config.response_body_method = nil }
    end

    it "extracts body from response object" do
      response = OpenStruct.new(body: '{"items": [1, 2, 3]}')
      expect(response).to have_json_size(3).at_path("items")
    end
  end
end
