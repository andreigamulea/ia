class TipconstitutionalsController < ApplicationController
  before_action :set_tipconstitutional, only: %i[ show edit update destroy ]

  # GET /tipconstitutionals or /tipconstitutionals.json
  def index
    @tipconstitutionals = Tipconstitutional.all.order(id: :asc)

  end
def evaluare_tipologie_ayurvedica
  @vata = Tipconstitutional.where(nrtip: 1).order(nr: :asc)
  @pitta = Tipconstitutional.where(nrtip: 2).order(nr: :asc)
  @kapha = Tipconstitutional.where(nrtip: 3).order(nr: :asc)
end  
def test1
end  
def process_totals
  totals = params[:totals].split(',').map(&:to_i)
  #totals este array-ul cu cele 3 valori
  sum = totals.sum
  if totals[0]==0 || totals[1]==0 || totals[2]==0
    verificare=0
    v, p, k = 0, 0, 0
  else
    
    verificare=1
    v=100*totals[0]/sum
    p=100*totals[1]/sum
    k=100*totals[2]/sum
  end    
  respond_to do |format|
    format.html do
      render partial: 'tipconstitutionals/total_sum', locals: { sum: sum,v: v,p: p,k: k,verificare: verificare }, layout: false
    end
    # Nu este necesar format.turbo_stream sau format.json dacă nu îi folosești
  end
end
  # GET /tipconstitutionals/1 or /tipconstitutionals/1.json
  def show
  end

  # GET /tipconstitutionals/new
  def new
    @tipconstitutional = Tipconstitutional.new
  end

  # GET /tipconstitutionals/1/edit
  def edit
  end

  # POST /tipconstitutionals or /tipconstitutionals.json
  def create
    @tipconstitutional = Tipconstitutional.new(tipconstitutional_params)

    respond_to do |format|
      if @tipconstitutional.save
        format.html { redirect_to tipconstitutional_url(@tipconstitutional), notice: "Tipconstitutional was successfully created." }
        format.json { render :show, status: :created, location: @tipconstitutional }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tipconstitutional.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tipconstitutionals/1 or /tipconstitutionals/1.json
  def update
    respond_to do |format|
      if @tipconstitutional.update(tipconstitutional_params)
        format.html { redirect_to tipconstitutional_url(@tipconstitutional), notice: "Tipconstitutional was successfully updated." }
        format.json { render :show, status: :ok, location: @tipconstitutional }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tipconstitutional.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tipconstitutionals/1 or /tipconstitutionals/1.json
  def destroy
    @tipconstitutional.destroy

    respond_to do |format|
      format.html { redirect_to tipconstitutionals_url, notice: "Tipconstitutional was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tipconstitutional
      @tipconstitutional = Tipconstitutional.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tipconstitutional_params
      params.require(:tipconstitutional).permit(:nrtip, :nr, :tip, :caracteristica)
    end
end
