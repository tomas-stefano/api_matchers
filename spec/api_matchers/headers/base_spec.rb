require 'spec_helper'

RSpec.describe APIMatchers::Headers::Base do
  subject { APIMatchers::Headers::Base.new }

  describe "#matches?" do
    it "should raise Not Implement Exception" do
      expect { subject.matches?('application/xml') }.to raise_error(NotImplementedError, "not implemented on #{subject}")
    end
  end

  describe "#setup" do
    it "returns the global Setup class" do
      expect(subject.setup).to eq APIMatchers::Core::Setup
    end
  end
end
