require 'spec_helper'

module APIMatchers::Core
  describe FindInJSON do
    describe "#find" do
      context 'when node exists' do
        it "should return the value of the expected key" do
          FindInJSON.new('product' => 'gateway').find(node: 'product').should eql 'gateway'
        end

        it "should return the value of the deep expected key in the json" do
          FindInJSON.new('transaction' => { 'error' => { 'code' => '999' } }).find(node: 'code').should eql '999'
        end
      end

      context 'when node do not exists' do
        it "should return nil if don't find the expected node" do
          expect{ FindInJSON.new('product' => 'pabx').find(node: 'developers').should raise_error( ::APIMatchers::Core::Exceptions::KeyNotFound ) }
        end

        it "should return nil if don't find the expected node in the deep JSON" do
          expect{ FindInJSON.new('transaction' => { 'id' => 150, 'error' => {} }).find(node: 'code').should raise_error( ::APIMatchers::Core::Exceptions::KeyNotFound ) }
        end
      end
    end
  end
end