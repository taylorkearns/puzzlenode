require 'debugger'
require 'nokogiri'

class RatesBuilder
  def self.build_from_xml(file_name)
    if file_name.split('.').last != 'xml'
      raise 'Wrong file type for transactions file.'
    else
      doc = Nokogiri::XML(open(file_name))

      rates = []

      doc.css('rate').each do |node|
        rates << self.build_rate(node)
      end

      rates
    end
  end

  private

  def self.build_rate(node)
    rate = {}

    rate[:from] = node.css('from').text
    rate[:to] = node.css('to').text
    rate[:conversion] = node.css('conversion').text.to_f

    rate
  end
end
