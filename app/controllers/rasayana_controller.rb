class RasayanaController < ApplicationController
  def modul1
    # Select the 5 products based on curslegatura and cod fields
    products = Prod.where(curslegatura: 'rasayana1', cod: ['cod234', 'cod235', 'cod236', 'cod237', 'cod238'])
    
    # User not logged in case
    if current_user.nil?
      # Display only the first and last products (p1 and p5)
      @prods = products.where(cod: ['cod234', 'cod238'])
      @nr_luni_achitate = 0 # No purchases, no months paid
    else
      # User is logged in, check purchases in ComenziProd
      purchased_prods = ComenziProd.where(user_id: current_user.id, validat: 'Finalizata')
                                   .joins(:prod)
                                   .where(prods: { curslegatura: 'rasayana1', status: 'activ' })
                                   .pluck('prods.cod')
  
      # Determine which products to show based on what has been purchased
      if purchased_prods.include?('cod238') # p5
        @prods = [] # None if p5 is purchased
        @nr_luni_achitate = 4
      elsif purchased_prods.include?('cod234') && purchased_prods.include?('cod235') && purchased_prods.include?('cod236') && purchased_prods.include?('cod237')
        @prods = [] # None if all p1, p2, p3, p4 are purchased
        @nr_luni_achitate = 4
      elsif purchased_prods.include?('cod234') && purchased_prods.include?('cod235') && purchased_prods.include?('cod236')
        @prods = products.where(cod: 'cod237') # p4 only
        @nr_luni_achitate = 3
      elsif purchased_prods.include?('cod234') && purchased_prods.include?('cod235')
        @prods = products.where(cod: 'cod236') # p3 only
        @nr_luni_achitate = 2
      elsif purchased_prods.include?('cod234')
        @prods = products.where(cod: 'cod235') # p2 only
        @nr_luni_achitate = 1
      else
        # If no purchases from the 5 products, show p1 and p5
        @prods = products.where(cod: ['cod234', 'cod238'])
        @nr_luni_achitate = 0
      end
    end
  end
  

end
