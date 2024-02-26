class ContracteUseri < ApplicationRecord 
    belongs_to :contracte #c.contracte_useris
    validates :nume_voluntar, :prenume, :strada_voluntar, :numarstrada_voluntar, :localitate_voluntar, :judet_voluntar,
     :telefon_voluntar, :email,  presence: true
     attr_accessor :validare_gdpr
     validates :semnatura1, presence: true, if: :validare_gdpr?
     
     attr_accessor :validare_semnatura_contract     
     validates :ci_voluntar, :eliberat_de, :perioada_contract, :eliberat_data, presence: true, if: :validare_semnatura_contract?
     validate :semnatura2_must_be_valid, if: :validare_semnatura_contract?


     attr_accessor :validare_semnatura3
     validates :semnatura3, presence: true, if: :validare_semnatura3?
     #validate :semnatura3_must_be_present, if: :validare_semnatura3?



     if Rails.env.development?
      after_validation :log_validation_errors
    end
    
    




  def semnatura2_must_be_valid
    # Înlăturăm prefixul pentru a lucra doar cu partea de base64 a semnăturii
    base64_data = semnatura2.sub(%r{^data:image/png;base64,}, '')
  
    # Decodificăm base64 pentru a obține datele binare ale imaginii
    decoded_data = Base64.decode64(base64_data)
   puts "Decoded data length: #{decoded_data.length}" # Afișăm lungimea datelor decodificate pentru inspectare
    # Verificăm dacă datele decodificate sunt sub un anumit prag (de exemplu, 100 de bytes)
    # Acest prag ar trebui ajustat în funcție de cât de mică este cea mai mică semnătură validă pe care o aștepți
    if decoded_data.length < 1320
      errors.add(:semnatura2, 'pare a fi gol sau invalid')
    end
  rescue ArgumentError
    # Acest bloc rescue este pentru cazul în care decodificarea base64 eșuează, indicând că string-ul nu este valid
    errors.add(:semnatura2, 'invalidă sau coruptă')
  end
     validate :semnatura_voluntar_must_be_present

     def semnatura_voluntar_must_be_present
        # Înlăturăm prefixul pentru a lucra doar cu partea de base64 a semnăturii
        base64_data = semnatura_voluntar.sub(%r{^data:image/png;base64,}, '')
      
        # Decodificăm base64 pentru a obține datele binare ale imaginii
        decoded_data = Base64.decode64(base64_data)
       puts "Decoded data length: #{decoded_data.length}" # Afișăm lungimea datelor decodificate pentru inspectare
        # Verificăm dacă datele decodificate sunt sub un anumit prag (de exemplu, 100 de bytes)
        # Acest prag ar trebui ajustat în funcție de cât de mică este cea mai mică semnătură validă pe care o aștepți
        if decoded_data.length < 100
          errors.add(:semnatura_voluntar, 'pare a fi gol sau invalid')
        end
      rescue ArgumentError
        # Acest bloc rescue este pentru cazul în care decodificarea base64 eșuează, indicând că string-ul nu este valid
        errors.add(:semnatura_voluntar, 'invalidă sau coruptă')
      end


      def semnatura3_must_be_present
        # Înlăturăm prefixul pentru a lucra doar cu partea de base64 a semnăturii
        base64_data = semnatura3.sub(%r{^data:image/png;base64,}, '')
      
        # Decodificăm base64 pentru a obține datele binare ale imaginii
        decoded_data = Base64.decode64(base64_data)
       puts "Decoded data length: #{decoded_data.length}" # Afișăm lungimea datelor decodificate pentru inspectare
        # Verificăm dacă datele decodificate sunt sub un anumit prag (de exemplu, 100 de bytes)
        # Acest prag ar trebui ajustat în funcție de cât de mică este cea mai mică semnătură validă pe care o aștepți
        if decoded_data.length < 100
          errors.add(:semnatura3, 'pare a fi gol sau invalid')
        end
      rescue ArgumentError
        # Acest bloc rescue este pentru cazul în care decodificarea base64 eșuează, indicând că string-ul nu este valid
        errors.add(:semnatura3, 'invalidă sau coruptă')
      end



      
      #validates :nume_voluntar,presence: true
      def validare_gdpr?
        validare_gdpr == true
      end
      def validare_semnatura_contract?
        puts "validare_semnatura_contract? called, returning: #{validare_semnatura_contract == true}"
        validare_semnatura_contract == true
      end
      def validare_semnatura3?
        puts "validare_semnatura3? called, returning: #{validare_semnatura3 == true}"
        validare_semnatura3 == true
      end
      
      def log_validation_errors
        if errors.any?
          puts "Validation errors for #{self.class.name} #{id || 'new record'}:"
          errors.full_messages.each { |message| puts message }
        end
      end
end
