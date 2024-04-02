class Listacanal2sController < ApplicationController
    def index
      unless current_user&.role == 1
        redirect_to root_path, alert: "Acces restricționat!" and return
      end
      @listacanal2s = Listacanal2.all
    end
  
    def show
      unless current_user&.role == 1
        redirect_to root_path, alert: "Acces restricționat!" and return
      end
      @listacanal2 = Listacanal2.find(params[:id])
    end
  
    def new
      unless current_user&.role == 1
        redirect_to root_path, alert: "Acces restricționat!" and return
      end
      @listacanal2 = Listacanal2.new
    end
  
    def create
      unless current_user&.role == 1
        redirect_to root_path, alert: "Acces restricționat!" and return
      end
      @listacanal2 = Listacanal2.new(listacanal2_params)
      if @listacanal2.save
        redirect_to @listacanal2, notice: 'Inregistrare creata cu succes.'
      else
        render :new
      end
    end
  
    def edit
      unless current_user&.role == 1
        redirect_to root_path, alert: "Acces restricționat!" and return
      end
      @listacanal2 = Listacanal2.find(params[:id])
    end
  
    def update
      unless current_user&.role == 1
        redirect_to root_path, alert: "Acces restricționat!" and return
      end
      @listacanal2 = Listacanal2.find(params[:id])
      puts("in update id: #{@listacanal2.platit}")
      if @listacanal2.update(listacanal2_params)
        redirect_to root_path, notice: 'Inregistrarea a fost actualizată cu succes.'
      else
        render :edit
      end
    end
    
  
    def destroy
      unless current_user&.role == 1
        redirect_to root_path, alert: "Acces restricționat!" and return
      end
      @listacanal2 = Listacanal2.find(params[:id])
      @listacanal2.destroy
      redirect_to listacanal2s_url, notice: 'Inregistrare stearsa.'
    end
  
    private
    def listacanal2_params
      params.require(:listacanal2).permit(:email, :platit, :nume, :telefon)
    end
  end
  