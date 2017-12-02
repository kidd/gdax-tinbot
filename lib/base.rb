require_relative "client"

module Trader
  class Base

    SLEEP = 0.5
    DEFAULT_PRODUCT_ID = "ETH-BTC"

    class << self
      def run(options = {})
        new(options).run
      end
    end

    attr_reader :rest_api, :product_id

    def initialize(options = {})
      @product_id = options[:product_id] || DEFAULT_PRODUCT_ID
      @options = options
      @rest_api = Client.client(product_id: @product_id)
    end

    def products
      @products ||= rest_api.products
    end

    def product
      @product ||= products.detect{|x| x.id == product_id}
    end

    def diff_amount
      product.quote_increment.to_f
    end

    def min_amount
      @options[:amount] || product.base_min_size.to_f
    end

    def round_to
      product["quote_increment"].split(".")[-1].length
    end

    def run
      get_last_trade
      new_order
      continue = true
      sleep SLEEP
      while continue
        get_last_trade
        update_last_order
        if @last_order && ["open", "rejected"].include?(@last_order.status)
          puts "status: #{@last_order.status}"
          # si es rejected y no cambia le precio no se está haciendo nada...
          if change_new_price?
            puts "price change"
            if cancell_last_order
              new_order
            end
          end
        elsif @last_order.status == "done"
          continue = false
        else
          new_order
        end
        sleep SLEEP
      end

      last_order_price
    end

    def new_order
      puts "new order"
      begin
        @last_order = nil
        @last_order = new_order_action

        if @last_order.status == "rejected"
          puts "order rejected"
          retry_new_order
        end
        @last_order
      rescue => e
        puts e
        retry_new_order
      end
    end

    def retry_new_order
      sleep SLEEP
      get_last_trade
      new_order
    end

    def cancell_last_order
      puts "Cancelling last order"
      if @last_order
        begin
          rest_api.cancel(@last_order.id)
          true
        rescue => e
          puts e
          false
        end
      end
    end

    def update_last_order
      if @last_order
        begin
          @last_order = rest_api.order(@last_order.id)
        rescue => e
          @last_order = nil
          puts e
        end
      end
    end

    def last_order_price
      round_price(@last_order.price)
    end

    def round_price(price)
      price.to_f.round(round_to)
    end

    def get_last_trade
      @old_trade = @last_trade
      @last_trade = rest_api.last_trade
    end

    def last_trade_price
      unless @last_trade
        get_last_trade
      end
      @last_trade.price.to_f.round(round_to+1)
    end
  end
end
