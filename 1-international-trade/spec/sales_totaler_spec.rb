require 'spec_helper'
require_relative '../sales_totaler'

describe SalesTotaler do
  before do
    @sales_totaler = SalesTotaler.new
  end

  describe '#total_product_sales' do
    it 'returns the total sales for the product' do
      # How to stub converted_amount?
      @sales_totaler.stub(:sku, 'T123')
      @sales_totaler.stub(:transactions, [
        { store: 'Hailey', sku: 'T123', amount: 10.00, currency: 'USD' },
        { store: 'Boise', sku: 'T555', amount: 15.00, currency: 'USD' },
        { store: 'Ketchum', sku: 'T123', amount: 20.00, currency: 'USD' }
      ]
    end
  end
end
