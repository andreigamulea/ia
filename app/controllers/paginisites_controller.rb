class PaginisitesController < ApplicationController
  before_action :set_paginisite, only: %i[ show edit update destroy ]

  # GET /paginisites or /paginisites.json
  def index
    @paginisites = Paginisite.all
  end

  # GET /paginisites/1 or /paginisites/1.json
  def show
  end

  # GET /paginisites/new
  def new
    @paginisite = Paginisite.new
  end

  # GET /paginisites/1/edit
  def edit
  end

  # POST /paginisites or /paginisites.json
  def create
    @paginisite = Paginisite.new(paginisite_params)

    respond_to do |format|
      if @paginisite.save
        format.html { redirect_to paginisite_url(@paginisite), notice: "Paginisite was successfully created." }
        format.json { render :show, status: :created, location: @paginisite }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @paginisite.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /paginisites/1 or /paginisites/1.json
  def update
    respond_to do |format|
      if @paginisite.update(paginisite_params)
        format.html { redirect_to paginisite_url(@paginisite), notice: "Paginisite was successfully updated." }
        format.json { render :show, status: :ok, location: @paginisite }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @paginisite.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /paginisites/1 or /paginisites/1.json
  def destroy
    @paginisite.destroy

    respond_to do |format|
      format.html { redirect_to paginisites_url, notice: "Paginisite was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  def userilogati
    # Încarcăm toate înregistrările din UserPaginisite unde numele paginii este 'Login'
    @q = UserPaginisite.includes(:user, :paginisite).
    where(paginisites: { nume: 'Login' }).order('user_paginisites.created_at DESC').ransack(params[:q])
    @user_paginisite = @q.result.order(:id).page(params[:page]).per(15)
    # Acum @user_paginisite conține toate înregistrările UserPaginisite unde numele paginii este 'Login', împreună cu detaliile corespunzătoare ale user-ilor și ale paginilor.
  end
  def useriunici_logati
    # Folosim SQL direct pentru a putea folosi 'DISTINCT ON'
    @q = UserPaginisite.includes(:user, :paginisite)
                                     .where(paginisites: { nume: 'Login' })
                                     .order('users.email, user_paginisites.created_at DESC')
                                     .select('DISTINCT ON (users.email) user_paginisites.*').ransack(params[:q])

    @user_paginisite = @q.result.order(:id).page(params[:page]).per(15)

  
    # Acum @user_paginisite conține înregistrările unice în funcție de email ale UserPaginisite unde numele paginii este 'Login', împreună cu cea mai recentă dată de creare pentru fiecare utilizator.
  end
  
  
  
    
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_paginisite
      @paginisite = Paginisite.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def paginisite_params
      params.require(:paginisite).permit(:nume)
    end
end
