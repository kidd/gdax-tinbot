require "tty-table"
require_relative "lib/client"

require "pry"
rest_api = Client.client
TO = "EUR"

table = TTY::Table.new header: ['PRODUCT_ID', "SIDE", "SIZE", "PRICE"]

rest_api.orders(status: "open").each do |order|
  table << [order.product_id, order.side, order["size"].to_f, order["price"].to_f]
end
puts table.render(:basic, alignment: :right)
