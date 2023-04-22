class GestionareUseriCursuriController < ApplicationController
  before_action :authenticate_user!, only: %i[index ]
  before_action :require_admin, only: [:index,:import_from_xlsx_cursantinutritie]
  def index
    @users = User.all
  end
  def import_from_xlsx_cursantinutritie
    xlsx = Roo::Spreadsheet.open(File.join(Rails.root, 'app', 'fisierele', 'cursantinutritie.xlsx'))
  
    xlsx.each_row_streaming(offset: 0) do |row|
      email = row[0]&.value
      name = row[1]&.value
      next if email.nil?
      next if User.exists?(email: email)
  
      user = User.new(email: email, password: "7777777", name: name, role: 0)
  
      if user.save
        u = User.find_by(email: email.downcase).id
  
        listacursuri = Listacursuri.find_by(nume: "Nutritie")
        return if listacursuri.nil?
  
        curs = Cursuri.new(
          user_id: u,
          listacursuri_id: listacursuri.id,
          datainceput: Date.today,
          datasfarsit: Date.new(2023, 12, 31)
        )
  
        if curs.save
          # Add a new entry in CursuriHistory table
          cursuri_history = CursuriHistory.new(
            user_id: u,
            listacursuri_id: listacursuri.id,
            cursuri_id: curs.id,
            datainceput: curs.datainceput,
            datasfarsit: curs.datasfarsit
          )
          cursuri_history.save
        end
      else
        next
      end
    end
    redirect_to gestionare_useri_cursuri_index_path, notice: "Datele au fost importate cu succes!"
  end
  
  def stergecursntinutritie
    Cursuri.destroy_all
    CursuriHistory.destroy_all
    User.where.not(email: "ilates@yahoo.com",email: "costelaioanei@yahoo.com").destroy_all
   

    
    redirect_to gestionare_useri_cursuri_index_path, notice: 'Toate înregistrările din tabela Valori Nutritionale au fost șterse!'
    
  end  
  private
  def require_admin
    unless current_user && current_user.role == 1
      flash[:error] = "Only admins are allowed to access this page."
      redirect_to root_path # sau o altă cale pe care doriți să o redirecționați utilizatorul
    end
  end
  
end

