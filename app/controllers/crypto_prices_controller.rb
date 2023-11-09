require 'httparty'

class CryptoPricesController < ApplicationController
  def show_doge_price
    begin
      @doge_prices = get_book_ticker('DOGEUSDT')
      @btc_prices = get_book_ticker('BTCUSDT')
      @xmr_prices = get_book_ticker('XMRUSDT')
      @eth_prices = get_book_ticker('ETHUSDT')
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
