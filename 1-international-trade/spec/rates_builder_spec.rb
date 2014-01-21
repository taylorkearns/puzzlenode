require 'spec_helper'
require_relative '../rates_builder'

describe RatesBuilder do
  before do
    file_name = 'SAMPLE_RATES.xml'
    @rates_builder = RatesBuilder.new(file_name)
  end

  describe '#build_rates' do
    it 'builds out all conversion rates' do
      expected_results = [
        { from: 'AUD', to: 'CAD', conversion: 1.0079 },
        { from: 'AUD', to: 'USD', conversion: 1.0170 },
        { from: 'CAD', to: 'AUD', conversion: 0.9922 },
        { from: 'CAD', to: 'USD', conversion: 1.009  },
        { from: 'USD', to: 'AUD', conversion: 0.9834 },
        { from: 'USD', to: 'CAD', conversion: 0.9911 }
      ]

      expect(@rates_builder.build_rates).to eq expected_results
    end
  end

  describe '#rates_from_xml' do
    it 'raises an error if the file is not xml' do
      file_name = 'file.pdf'

      expect{ RatesBuilder.new(file_name).rates_from_xml }.to raise_error(RuntimeError)
    end

    it 'returns a hash of conversion rates' do
      rates_file = 'SAMPLE_RATES.xml'

      expected_results = [
        { from: 'AUD', to: 'CAD', conversion: 1.0079 },
        { from: 'AUD', to: 'USD', conversion: nil    },
        { from: 'CAD', to: 'AUD', conversion: nil    },
        { from: 'CAD', to: 'USD', conversion: 1.009  },
        { from: 'USD', to: 'AUD', conversion: nil    },
        { from: 'USD', to: 'CAD', conversion: 0.9911 }
      ]

      expect(@rates_builder.rates_from_xml).to eq expected_results
    end
  end

  describe '#conversions_incomplete?' do
    it 'is false if all conversions are complete' do
      rates = [
        { from: 'AUD', to: 'CAD', conversion: 1.012 },
        { from: 'CAD', to: 'FLK', conversion: 0.012 },
        { from: 'FLK', to: 'CAD', conversion: 1.321 }
      ]

      expect(@rates_builder.conversions_incomplete?(rates)).to be_false
    end

    it 'is true if any conversions are nil' do
      rates = [
        { from: 'AUD', to: 'CAD', conversion: 1.012 },
        { from: 'CAD', to: 'FLK', conversion: nil   },
        { from: 'FLK', to: 'CAD', conversion: 1.321 }
      ]

      expect(@rates_builder.conversions_incomplete?(rates)).to be_true
    end
  end

  describe '#reverse_rate' do
    it 'returns the reverse rate from all rates' do
      rates = [
        { from: 'AUD', to: 'CAD', conversion: 1.0079 },
        { from: 'AUD', to: 'USD', conversion: 1.0170 },
        { from: 'CAD', to: 'AUD', conversion: nil    }
      ]

      rate = { from: 'AUD', to: 'CAD', conversion: 1.0079 }

      expected = { from: 'CAD', to: 'AUD', conversion: nil }

      expect(@rates_builder.reverse_rate(rates, rate)).to eq expected
    end
  end
end

=begin

===== SAMPLE_RATES.xml =====

<?xml version="1.0"?>
<rates>
  <rate>
    <from>AUD</from>
    <to>CAD</to>
    <conversion>1.0079</conversion>
  </rate>
  <rate>
    <from>CAD</from>
    <to>USD</to>
    <conversion>1.0090</conversion>
  </rate>
  <rate>
    <from>USD</from>
    <to>CAD</to>
    <conversion>0.9911</conversion>
  </rate>
</rates>

=end

