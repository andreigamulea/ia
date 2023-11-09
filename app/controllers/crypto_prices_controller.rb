require 'httparty'

class CryptoPricesController < ApplicationController
  def show_crypto_price
    begin
      @doge_prices = get_book_ticker('DOGEUSDT')
      @btc_prices = get_book_ticker('BTCUSDT')
      @xmr_prices = get_book_ticker('XMRUSDT')
      @eth_prices = get_book_ticker('ETHUSDT')



      @eth_btc_prices = get_book_ticker('ETHBTC') # Utilizează ETHBTC în loc de BTCETH
      #@eth_xmr_prices = get_book_ticker('ETHXMR')# presupunând că există această pereche
      @eth_xmr_prices = get_book_ticker('XMRETH')
      @xmr_btc_prices = get_book_ticker('XMRBTC') # presupunând că există această pereche
      puts("@eth_btc_prices=#{@eth_btc_prices}")
      puts("@eth_xmr_prices=#{@eth_xmr_prices}")
      puts("@xmr_btc_prices=#{@xmr_btc_prices}")

      @starting_btc = 0.001

      # Calculează cât ETH vei obține pentru 0.001 BTC
      @btc_to_eth = @starting_btc / @eth_btc_prices[:ask_price].to_f if @eth_btc_prices

      # Calculează cât XMR vei obține pentru ETH-ul obținut anterior
      @eth_to_xmr = @btc_to_eth / @eth_xmr_prices[:ask_price].to_f if @btc_to_eth && @eth_xmr_prices

      # Calculează cât BTC vei obține pentru XMR-ul obținut anterior
      @xmr_to_btc = @eth_to_xmr * @xmr_btc_prices[:bid_price].to_f if @eth_to_xmr && @xmr_btc_prices
    rescue HTTParty::Error => e
      flash[:error] = "Eroare la obținerea prețurilor: #{e.message}"
      redirect_to root_path and return
    end
  end

  private

  def get_book_ticker(symbol)
    response = HTTParty.get('https://api.binance.com/api/v3/ticker/bookTicker', query: { symbol: symbol })
    if response.success?
      {
        bid_price: response.parsed_response['bidPrice'],
        ask_price: response.parsed_response['askPrice']
      }
    else
      nil
    end
  end
end
