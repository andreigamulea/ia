module ContractesHelper
    def status_color(status)
        case status
        when 'required'
          'red'
        when 'pending'
          '#29B6F6'
        when 'succes'
          '#28a745'  
        else
          'defaultColor' # Sau orice altă culoare implicită
        end
      end
end
