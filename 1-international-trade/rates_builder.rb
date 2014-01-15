require 'byebug'
require 'nokogiri'

class RatesBuilder
  attr_accessor :rates

  def initialize(file_name)
    @file_name = file_name
    @rates = []
  end

  def build_rates
    rates = rates_from_xml

    #rates.each do |from, tos|
      #tos.each do |currency, rate|
        #if rate.nil?
          #if reverse_conversion_available?(rates, currency, from)
            #tos[currency] = (1 / rates[currency][from]).round(4)
          #else
            #tos.each do |c, r|
              #if !rates[c][currency].nil?
                #tos[currency] = (rates[from][c] * rates[c][currency]).round(4)
              #end
            #end
          #end
        #end
      #end
    #end
  end

  def rates_from_xml
    if @file_name.split('.').last != 'xml'
      raise 'Wrong file type for transactions file.'
    else
      permutations = currencies.repeated_permutation(2).to_a
        .delete_if { |perm| perm[0] == perm[1] }

      permutations.each do |perm|
        rates << Hash[:from, perm[0], :to, perm[1], :conversion, nil]
      end

      xml_rates.each do |xml_rate|
        add_conversion(xml_rate)
      end
    end

    rates
  end

  private

  def add_conversion(xml_rate)
    from = xml_rate.css('from').text
    to = xml_rate.css('to').text
    conversion = xml_rate.css('conversion').text.to_f

    rates.each do |rate|
      if rate[:from] == from && rate[:to] == to
        rate[:conversion] = conversion
      end
    end
  end

  def currencies
    xml_rates.map do |rate|
      [rate.css('from').text, rate.css('to').text]
    end.flatten.uniq.sort
  end

  def xml_data
    Nokogiri::XML(open(@file_name))
  end

  def xml_rates
    xml_data.css('rate')
  end
end
