require_relative 'transactions_builder'

class SalesTotaler
  attr_reader :sku, :transactions_file

  def initialize(transactions_file: transactions_file, rates_file: rates_file, sku: sku, currency: currency)
    @sku = sku
    @transactions_file = transactions_file
  end

  def total_product_sales
    total = 0

    transactions.each do |trans|
      total += converted_amount(trans.amount) if trans.sku == sku
    end

    total
  end

  def transactions
    TransactionsBuilder.build(transactions_file)
  end
end

SalesTotaler.new(transactions_file: 'TRANS.csv',
                 rates_file: 'RATES.xml',
                 sku: 'DM1182',
                 currency: 'USD').transactions
