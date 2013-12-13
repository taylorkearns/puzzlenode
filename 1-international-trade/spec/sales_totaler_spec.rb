require 'spec_helper'
require_relative '../sales_totaler'

describe SalesTotaler do
  before do
    @transactions_file = 'SAMPLE_TRANS.csv'
    @rates_file = 'SAMPLE_RATES.xml'
    @totaler_sku = 'DM1182'
    @totaler_currency = 'USD'

    @sales_totaler = SalesTotaler.new(transactions_file: @transactions_file,
                                      rates_file: @rates_file,
                                      totaler_sku: @totaler_sku,
                                      totaler_currency: @totaler_currency)
  end

  describe '#total_product_sales' do
    it 'returns the total sales for the product' do
      pending
      # How to stub converted_amount?
      # Error when stubbing :transactions
      transaction_data = [
        { store: 'Hailey', totaler_sku: @totaler_sku, amount: 10.00, totaler_currency: @totaler_currency },
        { store: 'Boise', totaler_sku: 'T555', amount: 15.00, totaler_currency: @totaler_currency },
        { store: 'Ketchum', totaler_sku: @totaler_sku, amount: 20.00, totaler_currency: @totaler_currency }
      ]

      @sales_totaler.stub(:transactions, transaction_data)
    end
  end
end
