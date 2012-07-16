require 'spec_helper'

describe APIMatchers::ResponseBody::Base do
  let(:setup) { OpenStruct.new(:response_body_method => :body) }
  subject { APIMatchers::ResponseBody::Base.new(setup: setup, expected_node: :status) }

  describe "#matches?" do
    it "should raise Not Implemented Error" do
      expect {
        subject.matches?("foo")
      }.to raise_error(NotImplementedError, "not implemented on #{subject}")
    end
  end

  describe "#setup" do
    it "should read from the initialize" do
      subject.setup.should equal setup
    end
  end

  describe "#expected_node" do
    it "should read from the initialize" do
      subject.expected_node.should equal :status
    end
  end

  describe "#response_body" do
    let(:body) { { :foo => :bar}.to_json }

    context 'when have configuration' do
      it "should call the method when is config" do
        subject.actual = OpenStruct.new(:body => body)
        subject.response_body.should eql body
      end
    end

    context 'when dont have configuration' do
      let(:setup) { OpenStruct.new(:response_body_method => nil) }
      subject { APIMatchers::ResponseBody::Base.new(setup: setup, expected_node: :status) }

      it "should return the actual when do not have config" do
        subject.actual = body
        subject.response_body.should eql body
      end
    end
  end
end