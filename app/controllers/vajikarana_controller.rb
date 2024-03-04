class VajikaranaController < ApplicationController
  def modul1
    @has_access = current_user&.role == 1
    if current_user  
      # Obține ID-urile produselor cumpărate de current_user, care sunt valide și a căror datasfarsit este azi sau în viitor
      purchased_prod_coduri = ComenziProd.where(user_id: current_user.id, 
                                          validat: 'Finalizata', 
                                          datainceput: ..Date.new(2024, 5, 24))                                          
                                   .joins(:prod)
                                   .where(prods: { curslegatura: 'vajikarana1', status: 'activ' })
                                   .pluck('prods.cod')
      purchased_prod_coduri1 = ComenziProd1.where(user_id: current_user.id, 
                                   validat: 'Finalizata', 
                                   datainceput: ..Date.new(2024, 5, 24))
                            .joins(:prod)
                            .where(prods: { curslegatura: 'vajikarana1', status: 'activ' })
                            .pluck('prods.cod')
# Adaugă codurile la array-ul existent și elimină duplicatele
purchased_prod_coduri.concat(purchased_prod_coduri1)
purchased_prod_coduri.concat(purchased_prod_coduri1).uniq!
@a_cumparat_macar_un_cod = purchased_prod_coduri.any? || current_user.role == 1


  
      # Logica pentru determinarea produselor de afișat în funcție de ce a cumpărat current_user
      if purchased_prod_coduri.include?('cod108') && purchased_prod_coduri.include?('cod109')
        @prods = Prod.none
        @has_access = true
      elsif purchased_prod_coduri.include?('cod108')
        @prods = Prod.where(cod: 'cod109')
      elsif purchased_prod_coduri.include?('cod110')
        @has_access = true
        @prods = Prod.none
      else
        # Dacă nu a cumpărat niciunul, afișează produsele cu cod=cod108 și cod=cod110
        @prods = Prod.where(cod: ['cod108', 'cod110'])
      end
  
      @prods_cumparate = Prod.where(cod: purchased_prod_coduri)
             
    else
      # Dacă nu există un current_user, afișează produsele cu cod=cod108 și cod=cod110
      @prods = Prod.where(curslegatura: 'vajikarana1', status: 'activ').where(cod: ['cod108', 'cod110']).order(:id)
      @prods_cumparate = Prod.none
      @videos_correspondente = Video.none
    end

      if @has_access
              if current_user && current_user.limba=='EN'
                @myvideo13 = Video.where(tip: 'vajikarana1').where('ordine > ? AND ordine < ?', 4000, 5000).order(ordine: :asc)
              else  
                    @myvideo13 = Video.where(tip: 'vajikarana1').where('ordine <= ?', 1000).order(ordine: :asc)
              end  
      else  
                @myvideo13 = Video.none
      end



      puts("Are acces? : #{@has_access}")
  end
  
end
