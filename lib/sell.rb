require_relative "client"
require_relative "base"

module Trader
  class Sell < Base

    def initialize(options = {})
      @min_price = options[:min_price]
      super
    end

    def new_order_action
      puts "Sell"
      rest_api.sell(min_amount, order_price, post_only: true)
    end

    def order_price
      base = if @min_price
               [last_trade_price, round_price(@min_price)].max
             else
               last_trade_price
             end

      round_price(base + diff_amount)
    end

    def change_new_price?
      last_order_price > order_price
    end
  end
end
