require_relative 'transactions_builder'
require_relative 'rates_builder'

class SalesTotaler
  def initialize(transactions_file: transactions_file,
                 rates_file: rates_file,
                 totaler_sku: totaler_sku,
                 totaler_currency: totaler_currency)

    @totaler_sku = totaler_sku
    @transactions_file = transactions_file
    @rates_file = rates_file
    @totaler_currency = totaler_currency
  end

  def total_product_sales
    total = 0

    relevant_transactions = transactions.keep_if { |t| t[:sku] == @totaler_sku }

    relevant_transactions.each do |t|
      total += converted_amount(t[:amount], t[:currency])
      total = total.round(2)

    end

    total
  end

  def converted_amount(amount, currency)
    rate = conversion_rates.detect do |rate|
      rate[:from] == currency && rate[:to] == @totaler_currency
    end

    amount * rate[:conversion]
    bankers_round(amount * rate[:conversion])
  end

  private

  def bankers_round(amount)
    if amount.to_s.split('.')[1].length >= 3
      hundredths  = amount.round(3).to_s[-2].to_i
      thousandths = amount.round(3).to_s[-1].to_i

      if hundredths % 2 == 0 && thousandths == 5
        return amount.round(2) - 0.01
      end
    end

    amount.round(2)
  end

  def transactions
    TransactionsBuilder.build(@transactions_file)
  end

  def conversion_rates
    RatesBuilder.new(@rates_file).build_rates
  end
end
