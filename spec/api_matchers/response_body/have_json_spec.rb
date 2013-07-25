require 'spec_helper'

describe APIMatchers::ResponseBody::HaveJson do
  describe "actual.should have_json" do
    context 'when pass' do
      it 'equal json' do
        ['Petshop', 'Dogs'].to_json.should have_json(['Petshop', 'Dogs'])
      end
    end

    context 'when fails' do
      it 'different json' do
        expect {
          ['Petshop', 'Cats'].to_json.should have_json(['Petshop', 'Dogs'])
        }.to fail_with(%Q{expect to have json: '["Petshop","Cats"]'. Got: '["Petshop", "Cats"]'.})
      end
    end
  end

  describe "actual.should_not have_json" do
    context 'when pass' do
      it 'different json' do
        ['Petshop', 'Cats'].to_json.should_not have_json(['Petshop', 'Dogs'])
      end
    end

    context 'when fails' do
      it 'equal json' do
        expect {
          ['Petshop', 'Cats'].to_json.should_not have_json(['Petshop', 'Cats'])
        }.to fail_with(%Q{expect to NOT have json: '["Petshop","Cats"]'.})
      end
    end
  end
end