class TraditiaAyurvedicaController < ApplicationController
  def amnaya
    @has_access = current_user&.role == 1     
    if current_user
      # Selectează toate produsele care corespund criteriilor
      eligible_prods = Prod.where(curslegatura: 'traditia_ayurvedica', status: 'activ').pluck(:id)
    
      # Obține ID-urile produselor cumpărate de current_user, care sunt valide și a căror datasfarsit este azi sau în viitor
      purchased_prod_ids = ComenziProd.where(user_id: current_user.id, 
                                             validat: 'Finalizata', 
                                             datasfarsit: Date.today..,
                                             prod_id: eligible_prods)
                                      .pluck(:prod_id)
    
      # Selectează produsele eligibile care nu au fost cumpărate de current_user
      @prods = Prod.where(id: eligible_prods - purchased_prod_ids).order(:id)
    
      # Selectează produsele cumpărate de current_user
      @prods_cumparate = Prod.where(id: purchased_prod_ids)
      coduri_produse_cumparate = @prods_cumparate.pluck(:cod) # Scoate codurile din produsele cumpărate: cod91..
      #pluck(:cod) este folosit pentru a obține un array de valori din coloana cod a produselor cumpărate.
      if current_user.role==1
        @videos_correspondente = Video.where(tip: "traditia_ayurvedica").order(:ordine)

      else  
      @videos_correspondente = Video.where(cod: coduri_produse_cumparate).order(:ordine)
      end
    else
      @prods = Prod.where(curslegatura: 'traditia_ayurvedica', status: 'activ').order(:id)
      # În cazul în care nu există un current_user, @prods_cumparate va fi gol
      @prods_cumparate = Prod.none
      @videos_correspondente= Video.none
    end
    
  end
end