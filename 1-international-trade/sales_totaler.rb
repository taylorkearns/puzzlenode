require_relative 'transactions_builder'

class SalesTotaler
  attr_reader :totaler_sku

  def initialize(transactions_file: transactions_file,
                 rates_file: rates_file,
                 totaler_sku: totaler_sku,
                 totaler_currency: totaler_currency)

    @totaler_sku = totaler_sku
    @transactions_file = transactions_file
    @rates_file = rates_file
  end

  def total_product_sales
    total = 0

    transactions.each do |t|
      total += converted_amount(t[:amount], t[:currency]) if t[:sku] == totaler_sku
    end

    total
  end

  def transactions
    TransactionsBuilder.build(@transactions_file)
  end

  def converted_amount(amount, currency)
    amount
    #if currency amount
  end

  private

  def conversions
    initial_conversions = parsed_rates

    puts initial_conversions
  end

  def parsed_rates
    RatesBuilder.build_from_xml(@rates_file)
  end
end

SalesTotaler.new(transactions_file: 'SAMPLE_TRANS.csv',
                 rates_file: 'SAMPLE_RATES.xml',
                 totaler_sku: 'DM1182',
                 totaler_currency: 'USD').total_product_sales
