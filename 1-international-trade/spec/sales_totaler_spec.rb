require 'spec_helper'
require_relative '../sales_totaler'

describe SalesTotaler do
  before do
    @transactions_file = 'SAMPLE_TRANS.csv'
    @rates_file = 'RATES.xml'
    @totaler_sku = 'DM1182'
    @totaler_currency = 'USD'

    @sales_totaler = SalesTotaler.new(transactions_file: @transactions_file,
                                      rates_file: @rates_file,
                                      totaler_sku: @totaler_sku,
                                      totaler_currency: @totaler_currency)
  end

  describe '#converted_amount' do
    it "returns the amount converted from AUD to USD" do
      expect(@sales_totaler.converted_amount(34.56, 'AUD')).to eq 35.15
    end

    it "returns the amount converted from CAD to USD" do
      expect(@sales_totaler.converted_amount(34.56, 'CAD')).to eq 34.87
    end

    it "returns the amount converted from EUR to USD" do
      expect(@sales_totaler.converted_amount(34.56, 'EUR')).to eq 47.25
    end

    it "applies banker's rounding to round up" do
      expect(@sales_totaler.converted_amount(5.00, 'EUR')).to eq 6.84 # 6.8355
    end

    it "applies banker's rounding to round down" do
      expect(@sales_totaler.converted_amount(3.3247, 'EUR')).to eq 4.54 # 4.5451
    end
  end
end
