require 'spec_helper'
require_relative '../rates_builder'

describe RatesBuilder do
  describe '.build_from_xml' do
    it 'raises an error if the file is not xml' do
      file_name = 'file.pdf'

      expect{ RatesBuilder.build_from_xml(file_name) }.to raise_error(RuntimeError)
    end

    it 'returns a hash of conversion rates' do
      rates_file = 'SAMPLE_RATES.xml'

      expected_results = [
        { from: 'AUD', to: 'CAD', conversion: 1.0079 },
        { from: 'CAD', to: 'USD', conversion: 1.0090 },
        { from: 'USD', to: 'CAD', conversion: 0.9911 }
      ]

      expect(RatesBuilder.build_from_xml(rates_file)).to eq expected_results
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

