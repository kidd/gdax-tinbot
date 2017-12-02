# Este script sirve para comparar el cambio de ETH a EUR ya sea de forma
# directa o pasando por BTC.

require_relative "lib/client"
require 'time'

rest_api = Client.client

old_info = nil
while true
  sleep 2
  btc_eur = rest_api.last_trade(product_id: "BTC-EUR")
  eth_btc = rest_api.last_trade(product_id: "ETH-BTC")
  eth_eur = rest_api.last_trade(product_id: "ETH-EUR")

  new_info = "ETH->BTC->EUR: #{'%.3f' % (btc_eur.price * eth_btc.price).to_f} | ETH-> EUR: #{'%.3f' % eth_eur.price.to_f}"

  if old_info != new_info
    puts new_info
  end
  old_info = new_info
end
