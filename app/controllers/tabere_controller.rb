class TabereController < ApplicationController
  def tayv24
   #@prod_tayt12 = Prod.where(curslegatura: 'tayt12').order(:cod)
   @prod_tayt12 = Prod.where(curslegatura: 'tayt12', status: 'activ').order(:cod)
   #@myvideo = Video.where(tip: 'tayt12').order(ordine: :asc)
   @myvideo = Video.where(tip: 'tayt12').where("ordine < ?", 1000).order(ordine: :asc)
   @myvideo3 = Video.where(tip: 'tayt12').where("ordine > ? AND ordine < ?", 3000, 4000).order(ordine: :asc)
   if current_user && current_user.limba=="EN"
     @myvideo4 = Video.where(tip: 'tayt12').where("ordine > ? AND ordine < ?", 5000, 6000).order(ordine: :asc)
   else
      @myvideo4 = Video.where(tip: 'tayt12').where("ordine > ? AND ordine < ?", 4000, 5000).order(ordine: :asc)
   end
   #@myvideo2 = Video.where(tip: 'tayt12').where("ordine > ?", 1000).order(ordine: :asc)
   if current_user && current_user.limba=="EN"
     @myvideo2 = Video.where(tip: 'tayt12').where("ordine > ? AND ordine < ?", 2000, 3000).order(ordine: :asc)
   else  
     @myvideo2 = Video.where(tip: 'tayt12').where("ordine > ? AND ordine < ?", 1000, 2000).order(ordine: :asc)
   end  

   if current_user
     @has_access = current_user.role == 1 || ComenziProd.joins(:prod)
     .where(user_id: current_user.id, prods: { cod: ["cod40", "cod41", "cod42", "cod43", "cod44", "cod45"] }, validat: "Finalizata").exists?
           
   else
     @has_access=false
   end  

   

   #@has_access_cursuri = ComenziProd.exists?(user_id: current_user.id, prod_id: 56)
   ##verific daca userul poate vedea videourile taberei(a platit?)
   if current_user
     prod_id_cod54 = Prod.find_by(cod: 'cod54')&.id
     prod_id_cod64 = Prod.find_by(cod: 'cod64')&.id
   
     @has_access_cursuri = current_user.role == 1 || (
       (prod_id_cod54 && 
        ComenziProd.where(user_id: current_user.id, prod_id: prod_id_cod54, validat: 'Finalizata')
                   .where('datasfarsit >= ?', Date.current)
                   .exists?) ||
       ComenziProd.joins(:prod)
                  .where(user_id: current_user.id, prods: { cod: ["cod41", "cod43", "cod45"] }, validat: 'Finalizata')
                  .where('datainceput >= ?', '2024-01-31')
                  .where('datasfarsit >= ?', Date.current)
                  .exists?
     )
     puts("@has_access_cursuri este: #{@has_access_cursuri}")
   
     @has_access_cursuri2 = current_user.role == 1 || (
       (prod_id_cod64 && 
        ComenziProd.where(user_id: current_user.id, prod_id: prod_id_cod64, validat: 'Finalizata')
                   .where('datasfarsit >= ?', Date.current)
                   .exists?) ||
       ComenziProd.joins(:prod)
                  .where(user_id: current_user.id, prods: { cod: ["cod40", "cod42", "cod44"] }, validat: 'Finalizata')
                  .where('datainceput >= ?', '2024-01-31')
                  .where('datasfarsit >= ?', Date.current)
                  .exists?
     )
     puts("@has_access_cursuri2 este: #{@has_access_cursuri2}")
   end
   
   
   
   
   
   
   
   Rails.logger.info("Avem @has_access_cursuri2=true") if @has_access_cursuri2
   
   
   if current_user && ComenziProd.joins(:prod)
     .where(user_id: current_user.id, prods: { cod: ['cod40', 'cod41', 'cod42', 'cod43', 'cod44', 'cod45'] }, validat: 'Finalizata')
     .where('datainceput >= ?', '2024-01-31')
     .where('datasfarsit >= ?', Date.current)
     .exists?
    @has_access = true
    @prod_tayt12a = Prod.where(cod: ['cod40', 'cod41', 'cod42', 'cod43', 'cod44', 'cod45'], status: 'activ').order(:luna)
  elsif !@has_access
    @prod_tayt12a = Prod.where(cod: ['cod40', 'cod41','cod42','cod43', 'cod44','cod45'], status: 'activ').order(:luna)
  else
    if !@has_access_cursuri && !@has_access_cursuri2
      @prod_tayt12a = Prod.where(cod: ['cod54', 'cod64'], status: 'activ').order(:cod)
    elsif @has_access_cursuri && !@has_access_cursuri2
      @prod_tayt12a = Prod.where(cod: 'cod64', status: 'activ').order(:cod)
    elsif !@has_access_cursuri && @has_access_cursuri2
      @prod_tayt12a = Prod.where(cod: 'cod54', status: 'activ').order(:cod)
    elsif @has_access_cursuri && @has_access_cursuri2
      @prod_tayt12a = Prod.none
    end
  end
end
end
