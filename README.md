# GDAX Tinbot

Este repo contiene algunos scripts y clases que interactúan con la API de Gdax.

## Adevertencia

No tengo ni idea de trading ni estoy siguiendo ninguna guía de trading, 
es posible que las estrategias que siga no sean eficientes, incluso puede que el 
código no haga lo que se supone que hace.

Este repositorio tiene el único objetivo de experimentar y aprender de forma practica.

## Para usarlo

Lo primero es generar el fichero `config.yml`

```
$ mv config.yml.sample config.yml
```

Este script muestra cuantos euros consigues por 1 ethereum de forma directa o mediante bitcoin.
```
$ ruby etheur.rb

ETH->BTC->EUR: 405.600 | ETH-> EUR: 403.990
```

**Compar y vender** 

Los modulos/clases: `Trader`, `Trader::Buy` y `Trader::Sell` son útiles para comprar y vender.
La idea es tratar de vender y comprar cuando la moneda baja y viceversa.

De momento trata de hacer las operaciones por las mínimas cantidades posibles por lo que los beneficios 
serán ridículos, pero las perdidas también.

Para usarlo abre la consola:

```ruby
 require "./trader"
 Trader.sell_buy(product_id: "ETH-BTC")
 ```
