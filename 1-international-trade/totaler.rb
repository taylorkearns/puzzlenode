require_relative 'sales_totaler'

SalesTotaler.new(transactions_file: 'TRANS.csv',
                 rates_file: 'RATES.xml',
                 totaler_sku: 'DM1182',
                 totaler_currency: 'USD').total_product_sales
