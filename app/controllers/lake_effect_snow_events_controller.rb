class LakeEffectSnowEventsController < ApplicationController
  before_action :set_lake_effect_snow_event, only: %i[ show edit update destroy ]

  # GET /lake_effect_snow_events or /lake_effect_snow_events.json
  def index
    @lake_effect_snow_events = LakeEffectSnowEvent.all
  end

  # GET /lake_effect_snow_events/1 or /lake_effect_snow_events/1.json
  def show
  end

  # GET /lake_effect_snow_events/new
  def new
    @lake_effect_snow_event = LakeEffectSnowEvent.new
  end

  # GET /lake_effect_snow_events/1/edit
  def edit
  end

  # POST /lake_effect_snow_events or /lake_effect_snow_events.json
  def create
    @lake_effect_snow_event = LakeEffectSnowEvent.new(lake_effect_snow_event_params)

    respond_to do |format|
      if @lake_effect_snow_event.save
        format.html { redirect_to lake_effect_snow_event_url(@lake_effect_snow_event), notice: "Lake effect snow event was successfully created." }
        format.json { render :show, status: :created, location: @lake_effect_snow_event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @lake_effect_snow_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lake_effect_snow_events/1 or /lake_effect_snow_events/1.json
  def update
    respond_to do |format|
      if @lake_effect_snow_event.update(lake_effect_snow_event_params)
        format.html { redirect_to lake_effect_snow_event_url(@lake_effect_snow_event), notice: "Lake effect snow event was successfully updated." }
        format.json { render :show, status: :ok, location: @lake_effect_snow_event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @lake_effect_snow_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lake_effect_snow_events/1 or /lake_effect_snow_events/1.json
  def destroy
    @lake_effect_snow_event.destroy

    respond_to do |format|
      format.html { redirect_to lake_effect_snow_events_url, notice: "Lake effect snow event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lake_effect_snow_event
      @lake_effect_snow_event = LakeEffectSnowEvent.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def lake_effect_snow_event_params
      params.require(:lake_effect_snow_event).permit(:eventName, :startDate, :endDate, :startTime, :endTime, :peakStartTime, :peakEndTime, :averageLakeSurfaceTemperature)
    end
end
