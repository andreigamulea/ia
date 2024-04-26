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
  def jivaka
    @has_access = current_user&.role == 1
    if current_user
      # Selectează toate produsele care corespund criteriilor
      eligible_prods = Prod.where(curslegatura: 'jivaka', status: 'activ').pluck(:id)
    
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
        @videos_correspondente = Video.where(tip: "jivaka").order(:ordine)

      else  
      @videos_correspondente = Video.where(cod: coduri_produse_cumparate).order(:ordine)
      end
    else
      @prods = Prod.where(curslegatura: 'jivaka', status: 'activ').order(:id)
      # În cazul în care nu există un current_user, @prods_cumparate va fi gol
      @prods_cumparate = Prod.none
      @videos_correspondente= Video.none
    end
  end  
  def cognitronica
    @has_access = current_user&.role == 1     
    if current_user
      # Selectează toate produsele care corespund criteriilor
      eligible_prods = Prod.where(curslegatura: 'cognitronica', status: 'activ').pluck(:id)
    
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
        @videos_correspondente = Video.where(tip: "cognitronica").order(:ordine)

      else  
      @videos_correspondente = Video.where(cod: coduri_produse_cumparate).order(:ordine)
      end
    else
      @prods = Prod.where(curslegatura: 'cognitronica', status: 'activ').order(:id)
      # În cazul în care nu există un current_user, @prods_cumparate va fi gol
      @prods_cumparate = Prod.none
      @videos_correspondente= Video.none
    end
    
  end
  
  def performanta_cognitiva
    @has_access = current_user&.role == 1     
    if current_user
      # Selectează toate produsele care corespund criteriilor
      eligible_prods = Prod.where(curslegatura: 'performanta_cognitiva', status: 'activ').pluck(:id)
    
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
        @videos_correspondente = Video.where(tip: "performanta_cognitiva").order(:ordine)

      else  
      @videos_correspondente = Video.where(cod: coduri_produse_cumparate).order(:ordine)
      end
    else
      @prods = Prod.where(curslegatura: 'performanta_cognitiva', status: 'activ').order(:id)
      # În cazul în care nu există un current_user, @prods_cumparate va fi gol
      @prods_cumparate = Prod.none
      @videos_correspondente= Video.none
    end

  end  
  def asita
    @has_access = current_user&.role == 1
    if current_user
      # Selectează toate produsele care corespund criteriilor
      eligible_prods = Prod.where(curslegatura: 'asita', status: 'activ').pluck(:id)
    
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
        @videos_correspondente = Video.where(tip: "asita").order(:ordine)

      else  
      @videos_correspondente = Video.where(cod: coduri_produse_cumparate).order(:ordine)
      end
    else
      @prods = Prod.where(curslegatura: 'asita', status: 'activ').order(:id)
      # În cazul în care nu există un current_user, @prods_cumparate va fi gol
      @prods_cumparate = Prod.none
      @videos_correspondente= Video.none
    end
  end
  def jamadagni
    @has_access = current_user&.role == 1
    if current_user
      # Selectează toate produsele care corespund criteriilor
      eligible_prods = Prod.where(curslegatura: 'jamadagni', status: 'activ').pluck(:id)
    
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
        @videos_correspondente = Video.where(tip: "jamadagni").order(:ordine)

      else  
      @videos_correspondente = Video.where(cod: coduri_produse_cumparate).order(:ordine)
      end
    else
      @prods = Prod.where(curslegatura: 'jamadagni', status: 'activ').order(:id)
      # În cazul în care nu există un current_user, @prods_cumparate va fi gol
      @prods_cumparate = Prod.none
      @videos_correspondente= Video.none
    end
  end

  def hiranyaksha
    @has_access = current_user&.role == 1
    if current_user
      # Selectează toate produsele care corespund criteriilor
      eligible_prods = Prod.where(curslegatura: 'hiranyaksha', status: 'activ').pluck(:id)
    
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
        @videos_correspondente = Video.where(tip: "hiranyaksha").order(:ordine)

      else  
      @videos_correspondente = Video.where(cod: coduri_produse_cumparate).order(:ordine)
      end
    else
      @prods = Prod.where(curslegatura: 'hiranyaksha', status: 'activ').order(:id)
      # În cazul în care nu există un current_user, @prods_cumparate va fi gol
      @prods_cumparate = Prod.none
      @videos_correspondente= Video.none
    end
  end


  def sharaloma
    @has_access = current_user&.role == 1
    if current_user
      # Selectează toate produsele care corespund criteriilor
      eligible_prods = Prod.where(curslegatura: 'sharaloma', status: 'activ').pluck(:id)
    
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
        @videos_correspondente = Video.where(tip: "sharaloma").order(:ordine)

      else  
      @videos_correspondente = Video.where(cod: coduri_produse_cumparate).order(:ordine)
      end
    else
      @prods = Prod.where(curslegatura: 'sharaloma', status: 'activ').order(:id)
      # În cazul în care nu există un current_user, @prods_cumparate va fi gol
      @prods_cumparate = Prod.none
      @videos_correspondente= Video.none
    end
  end

  def saunaka
    @has_access = current_user&.role == 1
    if current_user
      # Selectează toate produsele care corespund criteriilor
      eligible_prods = Prod.where(curslegatura: 'saunaka', status: 'activ').pluck(:id)
    
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
        @videos_correspondente = Video.where(tip: "saunaka").order(:ordine)

      else  
      @videos_correspondente = Video.where(cod: coduri_produse_cumparate).order(:ordine)
      end
    else
      @prods = Prod.where(curslegatura: 'saunaka', status: 'activ').order(:id)
      # În cazul în care nu există un current_user, @prods_cumparate va fi gol
      @prods_cumparate = Prod.none
      @videos_correspondente= Video.none
    end
  end
end
