require 'spec_helper'

RSpec.describe APIMatchers::ResponseBody::Base do
  subject { APIMatchers::ResponseBody::Base.new(expected_node: :status) }

  describe "#matches?" do
    it "should raise Not Implemented Error" do
      expect {
        subject.matches?("foo")
      }.to raise_error(NotImplementedError, "not implemented on #{subject}")
    end
  end

  describe "#setup" do
    it "returns the global Setup class" do
      expect(subject.setup).to eq APIMatchers::Core::Setup
    end
  end

  describe "#expected_node" do
    it "should read from the initialize" do
      expect(subject.expected_node).to equal :status
    end
  end

  describe "#response_body" do
    let(:body) { { :foo => :bar}.to_json }

    context 'when have configuration' do
      before do
        APIMatchers.setup { |config| config.response_body_method = :body }
      end

      after do
        APIMatchers.setup { |config| config.response_body_method = nil }
      end

      it "should call the method when is config" do
        subject.actual = OpenStruct.new(:body => body)
        expect(subject.response_body).to eql body
      end
    end

    context 'when dont have configuration' do
      before do
        APIMatchers.setup { |config| config.response_body_method = nil }
      end

      it "should return the actual when do not have config" do
        subject.actual = body
        expect(subject.response_body).to eql body
      end
    end
  end
end
