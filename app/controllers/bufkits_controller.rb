class BufkitsController < ApplicationController
  before_action :set_bufkit, only: %i[ show edit update destroy ]

  # GET /bufkits or /bufkits.json
  def index
    @bufkits = Bufkit.all
  end

  # GET /bufkits/1 or /bufkits/1.json
  def show
  end

  # GET /bufkits/new
  def new
    @bufkit = Bufkit.new
  end

  # GET /bufkits/1/edit
  def edit
  end

  # POST /bufkits or /bufkits.json
  def create
    @bufkit = Bufkit.new(bufkit_params)

    respond_to do |format|
      if @bufkit.save
        format.html { redirect_to bufkit_url(@bufkit), notice: "Bufkit was successfully created." }
        format.json { render :show, status: :created, location: @bufkit }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bufkit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bufkits/1 or /bufkits/1.json
  def update
    respond_to do |format|
      if @bufkit.update(bufkit_params)
        format.html { redirect_to bufkit_url(@bufkit), notice: "Bufkit was successfully updated." }
        format.json { render :show, status: :ok, location: @bufkit }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bufkit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bufkits/1 or /bufkits/1.json
  def destroy
    @bufkit.destroy

    respond_to do |format|
      format.html { redirect_to bufkits_url, notice: "Bufkit was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bufkit
      @bufkit = Bufkit.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def bufkit_params
      params.require(:bufkit).permit(:modelType, :lowTemp, :lowDew, :lowHumidity, :lowWindDirection, :lowWindSpeed, :lowHeight, :medTemp, :medDew, :medHumidity, :medWindDirection, :medWindSpeed, :medHeight, :highTemp, :highDew, :highHumidity, :highWindDirection, :highWindSpeed, :highHeight, :modelCape, :lakeEffectCape, :lakeEffectNCape, :lakeEffectEQL, :tenMeterWindDirection, :tenMeterWindSpeed, :lakeEffectSnowEvent_id)
    end
end
