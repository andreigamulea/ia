class Nutritie4Controller < ApplicationController
  def index 
    @has_access = current_user&.role == 1
    if current_user  
      # Obține ID-urile produselor cumpărate de current_user, care sunt valide și a căror datasfarsit este azi sau în viitor
      purchased_prod_coduri = ComenziProd.where(user_id: current_user.id, 
                                          validat: 'Finalizata', 
                                          datainceput: ..Date.new(2024, 5, 24))                                          
                                   .joins(:prod)
                                   .where(prods: { curslegatura: 'nutritie4', status: 'activ' })
                                   .pluck('prods.cod')
      purchased_prod_coduri1 = ComenziProd1.where(user_id: current_user.id, 
                                   validat: 'Finalizata', 
                                   datainceput: ..Date.new(2024, 5, 24))
                            .joins(:prod)
                            .where(prods: { curslegatura: 'nutritie4', status: 'activ' })
                            .pluck('prods.cod')
                            
# Adaugă codurile la array-ul existent și elimină duplicatele
purchased_prod_coduri.concat(purchased_prod_coduri1)
purchased_prod_coduri.concat(purchased_prod_coduri1).uniq!
puts("produsele cumparate sunt: #{purchased_prod_coduri}")
@a_cumparat_macar_un_cod = purchased_prod_coduri.any? || current_user.role == 1


  
      # Logica pentru determinarea produselor de afișat în funcție de ce a cumpărat current_user
      if purchased_prod_coduri.include?('cod85') && purchased_prod_coduri.include?('cod88')
        @prods = Prod.none
        @has_access = true
      elsif purchased_prod_coduri.include?('cod86')
              @has_access = true
              @prods = Prod.none

      elsif purchased_prod_coduri.include?('cod85')
        @prods = Prod.where(cod: 'cod88')
      
      else
        # Dacă nu a cumpărat niciunul, afișează produsele cu cod=cod108 și cod=cod110
        @prods = Prod.where(cod: ['cod85', 'cod86'])
      end
  
      @prods_cumparate = Prod.where(cod: purchased_prod_coduri)
             
    else
      # Dacă nu există un current_user, afișează produsele cu cod=cod108 și cod=cod110
      @prods = Prod.where(curslegatura: 'nutritie4', status: 'activ').where(cod: ['cod85', 'cod86']).order(:id)
      @prods_cumparate = Prod.none
      @videos_correspondente = Video.none
    end

      if @a_cumparat_macar_un_cod
              if current_user && current_user.limba=='EN'
                @myvideo13 = Video.where(tip: 'nutritie4').where('ordine > ? AND ordine < ?', 4000, 5000).order(ordine: :asc)
              else  
                    @myvideo13 = Video.where(tip: 'nutritie4').where('ordine <= ?', 1000).order(ordine: :asc)
              end  
      else  
                @myvideo13 = Video.none
      end



      puts("Are acces? : #{@has_access}")

  end
  def download
    linkzip = params[:linkzip]
    Rails.logger.debug "Parametrul linkzip este: #{linkzip}"
    decoded_linkzip = URI.decode_www_form_component(linkzip)
  
    # Determină tipul fișierului și setează tipul MIME corespunzător
    file_extension = File.extname(decoded_linkzip).downcase
    content_type = case file_extension
                   when ".rar"
                     'application/rar'
                   when ".7z"
                     'application/x-7z-compressed'
                   when ".pdf"
                     'application/pdf'
                   else
                     'application/octet-stream' # Tip generic, pentru cazul în care extensia fișierului nu este recunoscută
                   end
    
    # Construiește calea corectă
    file_path = Rails.root.join('public', 'pdf', 'vajikarana1', File.basename(decoded_linkzip))
    
    Rails.logger.debug "Calea este: #{file_path}"
    
    if File.exist?(file_path)
      send_file file_path, type: content_type, disposition: 'attachment'
    else
      redirect_to(root_url, alert: "Fișierul nu a fost găsit.")
    end
  end
end
