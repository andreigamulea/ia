class VajikaranaController < ApplicationController
  def modul1
    @has_access = current_user&.role == 1
    if current_user
      # Obține ID-urile produselor cumpărate de current_user, care sunt valide și a căror datasfarsit este azi sau în viitor
      purchased_prod_coduri = ComenziProd.where(user_id: current_user.id, 
                                                validat: 'Finalizata', 
                                                datasfarsit: Date.today..)
                                         .joins(:prod)
                                         .where(prods: { curslegatura: 'vajikarana1', status: 'activ' })
                                         .pluck('prods.cod')
  
      # Logica pentru determinarea produselor de afișat în funcție de ce a cumpărat current_user
      if purchased_prod_coduri.include?('cod108') && purchased_prod_coduri.include?('cod109')
        @prods = Prod.none
      elsif purchased_prod_coduri.include?('cod108')
        @prods = Prod.where(cod: 'cod109')
      elsif purchased_prod_coduri.include?('cod110')
        @prods = Prod.none
      else
        # Dacă nu a cumpărat niciunul, afișează produsele cu cod=cod108 și cod=cod110
        @prods = Prod.where(cod: ['cod108', 'cod110'])
      end
  
      @prods_cumparate = Prod.where(cod: purchased_prod_coduri)
      if @has_access
        @videos_correspondente = Video.where(tip: "vajikarana1").order(:ordine)
      else  
        @videos_correspondente = Video.where(cod: purchased_prod_coduri).order(:ordine)
      end
    else
      # Dacă nu există un current_user, afișează produsele cu cod=cod108 și cod=cod110
      @prods = Prod.where(curslegatura: 'vajikarana1', status: 'activ').where(cod: ['cod108', 'cod110']).order(:id)
      @prods_cumparate = Prod.none
      @videos_correspondente = Video.none
    end
  end
  
end
