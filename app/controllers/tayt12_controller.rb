class Tayt12Controller < ApplicationController

  def index
    # Nu am asociat încă un view pentru această metodă.
  end

  def transport_international
    unless user_signed_in?
      # Redirecționează spre pagina de login și adaugă parametrul 'return_to' în URL
      redirect_to new_user_session_path(return_to: 'tri') and return
    end
    
    # Logica acțiunii pentru utilizatorii autentificați.
    if current_user && current_user.email== 'tirolina9@yahoo.com'
      @prod_tayt12 = Prod.where(cod: "cod48")
    else
      @prod_tayt12 = Prod.where(cod: "cod63")
    end  
  end
  
end
