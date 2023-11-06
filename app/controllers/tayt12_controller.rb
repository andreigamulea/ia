class Tayt12Controller < ApplicationController
 
  def index #nu am asociat inca un view pt aceasta metoda
  end
  def transport_international
    @prod_tayt12 = Prod.where(cod: "cod63")
  end  
end
