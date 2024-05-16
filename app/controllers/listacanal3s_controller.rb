class Listacanal3sController < ApplicationController
    def index
      unless current_user&.role == 1
        redirect_to root_path, alert: "Acces restricționat!" and return
      end
      @listacanal3s = Listacanal3.all
    end
  
    def show
      unless current_user&.role == 1
        redirect_to root_path, alert: "Acces restricționat!" and return
      end
      @listacanal3 = Listacanal3.find(params[:id])
    end
  
    def new
      unless current_user&.role == 1
        redirect_to root_path, alert: "Acces restricționat!" and return
      end
      @listacanal3 = Listacanal3.new
    end
  
    def create
      unless current_user&.role == 1
        redirect_to root_path, alert: "Acces restricționat!" and return
      end
      @listacanal3 = Listacanal3.new(listacanal3_params)
      if @listacanal3.save
        redirect_to @listacanal3, notice: 'Inregistrare creata cu succes.'
      else
        render :new
      end
    end
  
    def edit
      unless current_user&.role == 1
        redirect_to root_path, alert: "Acces restricționat!" and return
      end
      @listacanal3 = Listacanal3.find(params[:id])
    end
  
    def update
      unless current_user&.role == 1
        redirect_to root_path, alert: "Acces restricționat!" and return
      end
      @listacanal3 = Listacanal3.find(params[:id])
      puts("in update id: #{@listacanal3.platit}")
      if @listacanal3.update(listacanal3_params)
        redirect_to root_path, notice: 'Inregistrarea a fost actualizată cu succes.'
      else
        render :edit
      end
    end
    
  
    def destroy
      unless current_user&.role == 1
        redirect_to root_path, alert: "Acces restricționat!" and return
      end
      @listacanal3 = Listacanal3.find(params[:id])
      @listacanal3.destroy
      redirect_to listacanal3s_url, notice: 'Inregistrare stearsa.'
    end
  
    private
    def listacanal3_params
      params.require(:listacanal3).permit(:email, :platit, :nume, :telefon)
    end
  end
  