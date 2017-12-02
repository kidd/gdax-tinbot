require "tty-table"
require_relative "lib/client"

require "pry"
rest_api = Client.client
TO = "EUR"

table = TTY::Table.new header: ['CURRENCY', "AMOUNT", "EUROS"]
sum = 0
rest_api.accounts.each do |account|
  currency = account.currency
  balance = account.balance.to_f
  output = [currency, balance]

  if currency != TO
		product_id = "#{currency}-EUR"
    ratio = rest_api.last_trade(product_id: product_id).price.to_f
		br = balance * ratio
    output << "%.2f" % br
		sum = sum + br
	else
    sum = sum + balance
		output << ""
  end

	table << output
end

table << [nil, "TOTAL", "%.2f" % sum]
puts table.render(:basic, alignment: :right)
