require 'spec_helper'

RSpec.describe APIMatchers::HTTPStatusCode::Base do
  let(:setup) { OpenStruct.new }
  subject { APIMatchers::HTTPStatusCode::Base.new(setup) }

  describe "#matches?" do
    it "should raise Not Implement Exception" do
      expect { subject.matches?(302) }.to raise_error(NotImplementedError, "not implemented on #{subject}")
    end
  end
end