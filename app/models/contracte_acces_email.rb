class ContracteAccesEmail < ApplicationRecord #aici contractorii adauga emailuri pt userii care vor semna un contract
    belongs_to :contracte #c.contracte_acces_emails #asa accesez
end
