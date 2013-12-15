require 'spec_helper'
require_relative '../rates_builder'

describe RatesBuilder do
  before do
    file_name = 'SAMPLE_RATES.xml'
    @rates_builder = RatesBuilder.new(file_name)
  end

  describe '#build_rates' do
    it 'builds out all conversion rates' do
      expected_results = {
        'AUD' => {
          'CAD' => 1.0079,
          'USD' => 1.0170
        },
        'CAD' => {
          'AUD' => 0.9922,
          'USD' => 1.009
        },
        'USD' => {
          'AUD' => 0.9833,
          'CAD' => 0.9911
        }
      }

      expect(@rates_builder.build_rates).to eq expected_results
    end
  end

  describe '#build_from_xml' do
    it 'raises an error if the file is not xml' do
      file_name = 'file.pdf'

      expect{ RatesBuilder.new(file_name).build_from_xml }.to raise_error(RuntimeError)
    end

    it 'returns a hash of conversion rates' do
      rates_file = 'SAMPLE_RATES.xml'

      expected_results = {
        'AUD' => {
          'CAD' => 1.0079,
          'USD' => nil
        },
        'CAD' => {
          'AUD' => nil,
          'USD' => 1.0090
        },
        'USD' => {
          'AUD' => nil,
          'CAD' => 0.9911
        }
      }

      expect(@rates_builder.build_from_xml).to eq expected_results
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

