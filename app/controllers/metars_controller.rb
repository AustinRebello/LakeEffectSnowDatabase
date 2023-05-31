class MetarsController < ApplicationController
  before_action :set_metar, only: %i[ show edit update destroy ]

  # GET /metars or /metars.json
  def index
    @metars = Metar.all
  end

  # GET /metars/1 or /metars/1.json
  def show
  end

  # GET /metars/new
  def new
    @metar = Metar.new
  end

  # GET /metars/1/edit
  def edit
  end

  # POST /metars or /metars.json
  def create
    @metar = Metar.new(metar_params)

    respond_to do |format|
      if @metar.save
        format.html { redirect_to metar_url(@metar), notice: "Metar was successfully created." }
        format.json { render :show, status: :created, location: @metar }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @metar.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /metars/1 or /metars/1.json
  def update
    respond_to do |format|
      if @metar.update(metar_params)
        format.html { redirect_to metar_url(@metar), notice: "Metar was successfully updated." }
        format.json { render :show, status: :ok, location: @metar }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @metar.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /metars/1 or /metars/1.json
  def destroy
    @metar.destroy

    respond_to do |format|
      format.html { redirect_to metars_url, notice: "Metar was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_metar
      @metar = Metar.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def metar_params
      params.require(:metar).permit(:site, :observationTime, :temperature, :dewPoint, :humidity, :windDirection, :windSpeed, :meanLevelSeaPressure, :visibility, :windGust, :presentWX, :peakWindGust, :peakWindDirection, :peakWindTime, :lakeEffectSnowEvent_id)
    end
end
