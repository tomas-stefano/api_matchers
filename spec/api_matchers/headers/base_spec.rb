require 'spec_helper'

RSpec.describe APIMatchers::Headers::Base do
  let(:setup) { OpenStruct.new }
  subject { APIMatchers::Headers::Base.new(setup) }

  describe "#matches?" do
    it "should raise Not Implement Exception" do
      expect { subject.matches?('application/xml') }.to raise_error(NotImplementedError, "not implemented on #{subject}")
    end
  end
end