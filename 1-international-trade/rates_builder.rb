require 'debugger'
require 'nokogiri'

class RatesBuilder
  attr_reader :file_name
  attr_accessor :rates, :froms

  def initialize(file_name)
    @file_name = file_name
    @rates = {}
    @froms = []
  end

  def build_rates
    rates = build_from_xml

    rates.each do |from, tos|
      tos.each do |currency, rate|
        if rate.nil?
          if reverse_conversion_available?(rates, currency, from)
            tos[currency] = (1 / rates[currency][from]).round(4)
          else
            tos.each do |c, r|
              if !rates[c][currency].nil?
                tos[currency] = (rates[from][c] * rates[c][currency]).round(4)
              end
            end
          end
        end
      end
    end
  end

  def build_from_xml
    if file_name.split('.').last != 'xml'
      raise 'Wrong file type for transactions file.'
    else
      doc = Nokogiri::XML(open(file_name))

      xml_rates = doc.css('rate')

      xml_rates.each { |node| build_froms(node) }

      froms.each { |node| build_tos(node) }

      xml_rates.each { |node| build_conversions(node) }

      rates
    end
  end

  private

  def reverse_conversion_available?(rates, currency, from)
    rates.has_key?(currency) && !rates[currency][from].nil?
  end

  def build_froms(node)
    froms = self.froms

    froms << node.css('from').text
    froms << node.css('to').text
    froms = froms.uniq.sort
  end

  def build_tos(node)
    rates[node] = {}

    self.froms.reject { |f| f == node }.each do |to|
      rates[node][to] = nil
    end
  end

  def build_conversions(node)
    from_node = node.css('from').text
    to_node = node.css('to').text
    conversion_node = node.css('conversion').text.to_f

    rates[from_node][to_node] = conversion_node
  end
end
