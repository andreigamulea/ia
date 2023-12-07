class ContractesController < ApplicationController
  before_action :set_contracte, only: %i[ show edit update destroy ]

  # GET /contractes or /contractes.json
  def index
    @contractes = Contracte.all
  end
  def semneaza_contract
    @contract=Contracte.all.first.textcontract
  end  

  # GET /contractes/1 or /contractes/1.json
  def show
  end

  # GET /contractes/new
  def new
    @contracte = Contracte.new
  end

  # GET /contractes/1/edit
  def edit
  end

  # POST /contractes or /contractes.json
  def create
    @contracte = Contracte.new(contracte_params)

    respond_to do |format|
      if @contracte.save
        format.html { redirect_to contracte_url(@contracte), notice: "Contracte was successfully created." }
        format.json { render :show, status: :created, location: @contracte }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @contracte.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contractes/1 or /contractes/1.json
  def update
    respond_to do |format|
      if @contracte.update(contracte_params)
        format.html { redirect_to contracte_url(@contracte), notice: "Contracte was successfully updated." }
        format.json { render :show, status: :ok, location: @contracte }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @contracte.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contractes/1 or /contractes/1.json
  def destroy
    @contracte.destroy

    respond_to do |format|
      format.html { redirect_to contractes_url, notice: "Contracte was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contracte
      @contracte = Contracte.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def contracte_params
      params.require(:contracte).permit(:user_id, :email, :tip, :denumire, :contor, :textcontract)
    end
end
