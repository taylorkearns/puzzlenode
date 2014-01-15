require 'byebug'
require 'csv'

class TransactionsBuilder
  def self.build(file_name)
    if file_name.split('.').last != 'csv'
      raise 'Wrong file type for transactions file.'
    else
      transactions = []

      CSV.foreach(file_name, headers: true) do |row|
        transactions << build_transaction(row)
      end

      transactions
    end
  end

  private

  def self.build_transaction(row)
    transaction = {}

    transaction[:store] = row[0]
    transaction[:sku] = row[1]
    transaction[:amount] = row[2].split(' ')[0].to_f
    transaction[:currency] = row[2].split(' ')[1]

    transaction
  end
end
