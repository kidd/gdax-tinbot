require "pry"
require_relative "lib/sell"
require_relative "lib/buy"

# Este modulo permite comprar/vender por la diferencia minima
#
# En la primera acción persigue el precio de match para conseguir hacer una
# operación tipo "maker" sin comisiones.
#
# En la siguiente operación simplemente se crea una orden que permita obtener
# algo de beneficio.
module Trader

  class << self
    # para cuando baja
    def sell_buy(options = {})
      sell_price = Trader::Sell.run(options)
      Trader::Buy.new(options.merge(max_price: sell_price)).new_order
    end

    # para cuando sube
    def buy_sell(options = {})
      buy_price = Trader::Buy.run(options)
      Trader::Sell.new(options.merge(min_price: buy_price)).new_order
    end
  end
end
