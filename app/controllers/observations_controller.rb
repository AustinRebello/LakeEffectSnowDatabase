class ObservationsController < ApplicationController
  before_action :set_observation, only: %i[ show edit update destroy ]

  def python
    @event = LakeEffectSnowEvent.find(params[:event_id])
    @eventID = @event.id
    @eSplit = @event.startDate.inspect.split('-')

    @obs = Observation.where(lake_effect_snow_event_id: @eventID)
    @obs.each do |ob|
        ob.destroy
    end

    @eventStartDate = Bufkit.handleDate(@event.startDate, @event.startTime)
    @eventEndDate = Bufkit.handleDate(@event.endDate, @event.endTime)
    @eventLake = @event.averageLakeSurfaceTemperature
    @output = `python lib/assets/getRealObs.py "#{@eventStartDate}" "#{@eventEndDate}"`
    Observation.python(@output, @eventID)
    redirect_to lake_effect_snow_event_url(@event)
  end

  def downloadCSV
    @event = LakeEffectSnowEvent.find(params[:event_id])
    respond_to do |format|
      format.html
      format.csv { send_data Observation.download(params[:event_id]), filename: "SURFACE-OBSERVATIONS-#{@event.eventName}.csv"}
    end
  end

  # GET /observations or /observations.json
  def index
    @observations = Observation.all
  end

  # GET /observations/1 or /observations/1.json
  def show
  end

  # GET /observations/new
  def new
    @observation = Observation.new
  end

  # GET /observations/1/edit
  def edit
  end

  # POST /observations or /observations.json
  def create
    @observation = Observation.new(observation_params)

    respond_to do |format|
      if @observation.save
        format.html { redirect_to observation_url(@observation), notice: "Observation was successfully created." }
        format.json { render :show, status: :created, location: @observation }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @observation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /observations/1 or /observations/1.json
  def update
    respond_to do |format|
      if @observation.update(observation_params)
        format.html { redirect_to observation_url(@observation), notice: "Observation was successfully updated." }
        format.json { render :show, status: :ok, location: @observation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @observation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /observations/1 or /observations/1.json
  def destroy
    @observation.destroy

    respond_to do |format|
      format.html { redirect_to observations_url, notice: "Observation was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_observation
      @observation = Observation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def observation_params
      params.require(:observation).permit(:site, :date, :surPressure, :surTemperature, :surDewPoint, :surHumidity, :surWindDirection, :surWindSpeed, :surHeight, :ninePressure, :nineTemperature, :nineDewPoint, :nineHumidity, :nineWindDirection, :nineWindSpeed, :nineHeight, :eightPressure, :eightTemperature, :eightDewPoint, :eightHumidity, :eightWindDirection, :eightWindSpeed, :eightHeight, :sevenPressure, :sevenTemperature, :sevenDewPoint, :sevenHumidity, :sevenWindDirection, :sevenWindSpeed, :sevenHeight, :lake_effect_snow_event_id)
    end
end