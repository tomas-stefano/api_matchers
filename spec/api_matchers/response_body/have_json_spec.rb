require 'spec_helper'

RSpec.describe APIMatchers::ResponseBody::HaveJson do
  describe "actual).to have_json" do
    context 'when pass' do
      it 'equal json' do
        expect(['Petshop', 'Dogs'].to_json).to have_json(['Petshop', 'Dogs'])
      end

      it 'compares with Hash too' do
        expect({ 'offers' => [10, 90] }.to_json).to have_json({ 'offers' => [10,90] })
      end
    end

    context 'when fails' do
      it 'fails with the expected response nd the actual body in the fail message' do
        expect {
          expect(['Petshop', 'Cats'].to_json).to have_json(['Petshop', 'Dogs'])
        }.to fail_with(%Q{expect to have json: '["Petshop", "Dogs"]'. Got: '["Petshop", "Cats"]'.})
      end
    end
  end

  describe "actual).not_to have_json" do
    context 'when pass' do
      it 'different json' do
        expect(['Petshop', 'Cats'].to_json).not_to have_json(['Petshop', 'Dogs'])
      end
    end

    context 'when fails' do
      it 'equal json returns the fail message for expect not to' do
        expect {
          expect(['Petshop', 'Cats'].to_json).not_to have_json(['Petshop', 'Cats'])
        }.to fail_with(%Q{expect to NOT have json: '["Petshop","Cats"]'.})
      end
    end
  end
end