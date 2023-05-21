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
    search_term = params[:search]
    @q = UserPaginisite.includes(:user, :paginisite).where(paginisites: { nume: 'Login' }).ransack(
      user_email_cont: search_term, 
      user_name_cont: search_term, 
      m: 'or'
    )
    @user_paginisite = @q.result.order('user_paginisites.created_at DESC').page(params[:page]).per(15)
  end
  
  
  def useriunici_logati
    search_term = params[:search]
    
    # Subquery to get the max created_at for each user_id
    subquery = UserPaginisite.group(:user_id).select('user_id, MAX(created_at) as max_created_at')
    
    # Main query to get the UserPaginisite records where each user_id has the latest created_at
    @q = UserPaginisite.joins("INNER JOIN (#{subquery.to_sql}) sub ON user_paginisites.user_id = sub.user_id AND user_paginisites.created_at = sub.max_created_at")
                       .includes(:user, :paginisite)
                       .where(paginisites: { nume: 'Login' })
                       .ransack(
                         user_email_cont: search_term, 
                         user_name_cont: search_term, 
                         m: 'or'
                       )
  
    @user_paginisite = @q.result.order('user_paginisites.created_at DESC').page(params[:page]).per(15)
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
