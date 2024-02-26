class ContracteUseri < ApplicationRecord 
    belongs_to :contracte #c.contracte_useris
    validates :nume_voluntar, :prenume, :strada_voluntar, :numarstrada_voluntar, :localitate_voluntar, :judet_voluntar,
     :telefon_voluntar, :email,  presence: true
     attr_accessor :validare_gdpr
     validates :semnatura1, presence: true, if: :validare_gdpr?

     
     #validates :semnatura2, :ci_voluntar, :eliberat_de, :eliberat_data, presence: true, on: :salveaza_contract


     validate :semnatura_voluntar_must_be_present

     def semnatura_voluntar_must_be_present
        # Înlăturăm prefixul pentru a lucra doar cu partea de base64 a semnăturii
        base64_data = semnatura_voluntar.sub(%r{^data:image/png;base64,}, '')
      
        # Decodificăm base64 pentru a obține datele binare ale imaginii
        decoded_data = Base64.decode64(base64_data)
      
        # Verificăm dacă datele decodificate sunt sub un anumit prag (de exemplu, 100 de bytes)
        # Acest prag ar trebui ajustat în funcție de cât de mică este cea mai mică semnătură validă pe care o aștepți
        if decoded_data.length < 100
          errors.add(:semnatura_voluntar, 'pare a fi gol sau invalid')
        end
      rescue ArgumentError
        # Acest bloc rescue este pentru cazul în care decodificarea base64 eșuează, indicând că string-ul nu este valid
        errors.add(:semnatura_voluntar, 'invalidă sau coruptă')
      end
      
      #validates :nume_voluntar,presence: true
      def validare_gdpr?
        validare_gdpr == true
      end
end
