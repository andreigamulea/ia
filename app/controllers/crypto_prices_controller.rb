require 'httparty'

class CryptoPricesController < ApplicationController
    def show_doge_price
        begin
          response = HTTParty.get('https://api.binance.com/api/v3/ticker/price', query: { symbol: 'DOGEUSDT' })
          puts "Răspuns API: #{response.parsed_response.inspect}"
          if response.success?
            # Presupunând că răspunsul este JSON și include un key 'price'
            @doge_price = response.parsed_response['price']
          else
            flash[:error] = "Eroare la obținerea prețului."
            redirect_to root_path and return
          end
        rescue HTTParty::Error => e
          flash[:error] = "Eroare la obținerea prețului: #{e.message}"
          redirect_to root_path and return
        end
      end
      
end
