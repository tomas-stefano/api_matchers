require 'spec_helper'

RSpec.describe APIMatchers::Collection::BeSortedBy do
  describe "actual.to be_sorted_by" do
    context "ascending order (default)" do
      it "passes when array is sorted ascending" do
        json = '[{"id": 1}, {"id": 2}, {"id": 3}]'
        expect(json).to be_sorted_by(:id)
      end

      it "passes when array is sorted ascending (explicit)" do
        json = '[{"id": 1}, {"id": 2}, {"id": 3}]'
        expect(json).to be_sorted_by(:id).ascending
      end

      it "fails when array is not sorted ascending" do
        json = '[{"id": 3}, {"id": 1}, {"id": 2}]'
        expect {
          expect(json).to be_sorted_by(:id).ascending
        }.to fail_with(/expected JSON array at 'root' to be sorted by 'id' ascending/)
      end
    end

    context "descending order" do
      it "passes when array is sorted descending" do
        json = '[{"id": 3}, {"id": 2}, {"id": 1}]'
        expect(json).to be_sorted_by(:id).descending
      end

      it "fails when array is not sorted descending" do
        json = '[{"id": 1}, {"id": 2}, {"id": 3}]'
        expect {
          expect(json).to be_sorted_by(:id).descending
        }.to fail_with(/expected JSON array at 'root' to be sorted by 'id' descending/)
      end
    end

    context "with at_path" do
      it "checks sorting at specified path" do
        json = '{"users": [{"name": "Alice"}, {"name": "Bob"}, {"name": "Charlie"}]}'
        expect(json).to be_sorted_by(:name).at_path("users")
      end
    end

    context "with string values" do
      it "sorts strings alphabetically" do
        json = '[{"name": "Alice"}, {"name": "Bob"}, {"name": "Charlie"}]'
        expect(json).to be_sorted_by(:name)
      end
    end

    context "with date strings" do
      it "sorts date strings" do
        json = '[{"created_at": "2023-01-01"}, {"created_at": "2023-06-15"}, {"created_at": "2023-12-31"}]'
        expect(json).to be_sorted_by(:created_at)
      end

      it "checks descending date order" do
        json = '[{"created_at": "2023-12-31"}, {"created_at": "2023-06-15"}, {"created_at": "2023-01-01"}]'
        expect(json).to be_sorted_by(:created_at).descending
      end
    end

    context "with empty array" do
      it "passes for empty array" do
        json = '[]'
        expect(json).to be_sorted_by(:id)
      end
    end

    context "with single element" do
      it "passes for single element array" do
        json = '[{"id": 1}]'
        expect(json).to be_sorted_by(:id)
      end
    end

    context "when path does not exist" do
      it "fails with descriptive message" do
        json = '{"data": []}'
        expect {
          expect(json).to be_sorted_by(:id).at_path("users")
        }.to fail_with(/but path was not found/)
      end
    end

    context "when value is not an array" do
      it "fails with descriptive message" do
        json = '{"user": {"id": 1}}'
        expect {
          expect(json).to be_sorted_by(:id).at_path("user")
        }.to fail_with(/path was not found or value was not an array/)
      end
    end
  end

  describe "actual.not_to be_sorted_by" do
    it "passes when not sorted" do
      json = '[{"id": 3}, {"id": 1}, {"id": 2}]'
      expect(json).not_to be_sorted_by(:id)
    end

    it "fails when sorted" do
      json = '[{"id": 1}, {"id": 2}, {"id": 3}]'
      expect {
        expect(json).not_to be_sorted_by(:id)
      }.to fail_with(/expected JSON array at 'root' NOT to be sorted by 'id' ascending/)
    end
  end
end
