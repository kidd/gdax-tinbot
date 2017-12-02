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
    def sell_buy(min_price: nil, product_id: nil)
      sell_price = Trader::Sell.run(min_price: min_price, product_id: product_id)
      Trader::Buy.new(max_price: sell_price, product_id: product_id).new_order
    end

    # para cuando sube
    def buy_sell(max_price: nil, product_id: nil)
      buy_price = Trader::Buy.run(max_price: max_price, product_id: product_id)
      Trader::Sell.new(min_price: buy_price, product_id: product_id).new_order
    end
  end
end
