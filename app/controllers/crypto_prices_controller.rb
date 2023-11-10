require 'httparty'

class CryptoPricesController < ApplicationController
  def show_crypto_price
    begin
      btc_usdt_ticker = get_book_ticker('BTCUSDT')
      if btc_usdt_ticker
        @btc_usdt_bid_price = btc_usdt_ticker[:bid_price]
        @btc_usdt_ask_price = btc_usdt_ticker[:ask_price]
        
      end
      # Pentru ETH/USDT
      eth_usdt_ticker = get_book_ticker('ETHUSDT')
      if eth_usdt_ticker
        @eth_usdt_bid_price = eth_usdt_ticker[:bid_price]
        @eth_usdt_ask_price = eth_usdt_ticker[:ask_price]
      end

      # Pentru XMR/USDT
      xmr_usdt_ticker = get_book_ticker('XMRUSDT')
      if xmr_usdt_ticker
        @xmr_usdt_bid_price = xmr_usdt_ticker[:bid_price]
        @xmr_usdt_ask_price = xmr_usdt_ticker[:ask_price]
      end

      @doge_prices = get_book_ticker('DOGEUSDT')
      @btc_prices = get_book_ticker('BTCUSDT')
      @xmr_prices = get_book_ticker('XMRUSDT')
      @eth_prices = get_book_ticker('ETHUSDT')



      @eth_btc_prices = get_book_ticker('ETHBTC') # Utilizează ETHBTC în loc de BTCETH
      #@eth_xmr_prices = get_book_ticker('ETHXMR')# presupunând că există această pereche
      @eth_xmr_prices = get_book_ticker('XMRETH')
      
      @xmr_btc_prices = get_book_ticker('XMRBTC') # presupunând că există această pereche
     
      @starting_btc = 0.001

      # Calculează cât ETH vei obține pentru 0.001 BTC
      @btc_to_eth = @starting_btc / @eth_btc_prices[:ask_price].to_f if @eth_btc_prices

      # Calculează cât XMR vei obține pentru ETH-ul obținut anterior
      @eth_to_xmr = @btc_to_eth / @eth_xmr_prices[:ask_price].to_f if @btc_to_eth && @eth_xmr_prices

      # Calculează cât BTC vei obține pentru XMR-ul obținut anterior
      @xmr_to_btc = @eth_to_xmr * @xmr_btc_prices[:bid_price].to_f if @eth_to_xmr && @xmr_btc_prices

      @eth_for_btc_c =  @btc_to_eth if @btc_to_eth
      @eth_for_btc_v = @btc_to_eth = @starting_btc / @eth_btc_prices[:bid_price].to_f if @eth_btc_prices

      @xmr_for_eth_c =  @eth_to_xmr if @eth_to_xmr
      @xmr_for_eth_v = @btc_to_eth / @eth_xmr_prices[:bid_price].to_f if @btc_to_eth && @eth_xmr_prices
      @btc_for_xmr_c =  @xmr_to_btc if @xmr_to_btc
      @btc_for_xmr_v = @eth_to_xmr * @xmr_btc_prices[:ask_price].to_f if @eth_to_xmr && @xmr_btc_prices

      
    rescue HTTParty::Error => e
      flash[:error] = "Eroare la obținerea prețurilor: #{e.message}"
      redirect_to root_path and return
    end
  end

  private

  def get_book_ticker(symbol)
    response = HTTParty.get('https://api.binance.com/api/v3/ticker/bookTicker', query: { symbol: symbol })
    if response.success?
      bid_price = response.parsed_response['bidPrice'].to_f
      ask_price = response.parsed_response['askPrice'].to_f
      {
        bid_price: bid_price,
        ask_price: ask_price,
        bid_volume: response.parsed_response['bidQty'], # Volumul pentru bid
        ask_volume: response.parsed_response['askQty'], # Volumul pentru ask
        btc_to_bid: 0.001 / bid_price, # Cât poți cumpăra cu 0.001 BTC la prețul de bid
        btc_to_ask: 0.001 / ask_price  # Cât poți vinde cu 0.001 BTC la prețul de ask
      }
    else
      nil
    end
  end
end
