require 'spec_helper'
require_relative '../transactions_builder'

describe TransactionsBuilder do
  describe '.build' do
    it 'raises an error if the file is not csv' do
      file_name = 'file.pdf'

      expect{ TransactionsBuilder.build(file_name) }.to raise_error(RuntimeError)
    end

    it 'returns a hash of transactions' do
      file_name = 'SAMPLE_TRANS.csv'
      expected_result = [
        { store: 'Yonkers',  sku: 'DM1210', amount: 70.00, currency: 'USD' },
        { store: 'Yonkers',  sku: 'DM1182', amount: 19.68, currency: 'AUD' },
        { store: 'Nashua',   sku: 'DM1182', amount: 58.58, currency: 'AUD' },
        { store: 'Scranton', sku: 'DM1210', amount: 68.76, currency: 'USD' },
        { store: 'Camden',   sku: 'DM1182', amount: 54.64, currency: 'USD' }
      ]

      expect(TransactionsBuilder.build(file_name)).to eq(expected_result)
    end
  end
end
