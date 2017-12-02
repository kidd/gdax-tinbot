require_relative "client"
require_relative "base"

module Trader
  class Buy < Base

    attr_reader :rest_api

    def initialize(options = {})
      @max_price = options[:max_price]
      super
    end

    def new_order_action
      puts "buy"
      rest_api.buy(min_amount, order_price, post_only: true)
    end

    def order_price
      base = if @max_price
              [last_trade_price, @max_price].min
             else
               last_trade_price
             end
      round_price(base - diff_amount)
    end

    def change_new_price?
      last_order_price < order_price
    end
  end
end
