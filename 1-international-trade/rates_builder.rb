require 'nokogiri'

class RatesBuilder
  def initialize(file_name)
    @file_name = file_name
  end

  def build_rates(rates=nil)
    rates = rates_from_xml if rates.nil?

    if conversions_incomplete?(rates)
      rates.each do |rate|
        rates = extrapolated_rates(rates, rate) unless rate[:conversion].nil?
      end
    else
      return rates
    end

    build_rates(rates)
  end

  def rates_from_xml
    if @file_name.split('.').last != 'xml'
      raise 'Wrong file type for transactions file.'
    else
      rates = []

      permutations = currencies.repeated_permutation(2).to_a
        .delete_if { |perm| perm[0] == perm[1] }

      permutations.each do |perm|
        rates << Hash[:from, perm[0], :to, perm[1], :conversion, nil]
      end

      xml_rates.each do |xml_rate|
        add_conversion(rates, xml_rate)
      end
    end

    rates
  end

  def conversions_incomplete?(rates)
    rates.each do |rate|
      return true if rate.has_value? nil
    end

    false
  end

  def reverse_rate(rates, rate)
    rates.detect { |r| r[:from] == rate[:to] && r[:to] == rate[:from] }
  end

  private

  def extrapolated_rates(rates, rate)
    completed_rates = rates.select { |r| !r[:conversion].nil? }

    completed_rates.each do |rate|
      reverse = reverse_rate(rates, rate)

      if reverse[:conversion].nil?
        reverse[:conversion] = reverse_conversion(rate[:conversion])
      else
        rates = rates_with_derived(rates, rate)
      end
    end

    rates
  end

  def rates_with_derived(rates, rate)
    from = rate[:from]
    to = rate[:to]

    related_rates = rates.select do |r|
      r[:from] == to && !r[:conversion].nil? && r != reverse_rate(rates, rate)
    end

    if related_rates.any?
      related_rates.each do |related|
        derived_rate = rates.detect do |rate|
          rate[:from] == from && rate[:to] == related[:to]
        end

        if derived_rate[:conversion].nil?
          derived_rate[:conversion] =
            (rate[:conversion] * related[:conversion]).round(4)
        end
      end
    end

    rates
  end

  def reverse_conversion(conversion)
    (1 / conversion).round(4)
  end

  def add_conversion(rates, xml_rate)
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
