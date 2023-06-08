class LakeEffectSnowEventsController < ApplicationController
  before_action :set_lake_effect_snow_event, only: %i[ show edit update destroy ]
  

  def report
    @snowReports = SnowReport.where(lake_effect_snow_event_id: params[:id])
    @snowReports.each do |report|
        report.destroy
    end
    @event = LakeEffectSnowEvent.where id: params[:id]
    redirect_to lake_effect_snow_event_url(@event)
  end

  def bufkit
    @bufkits = Bufkit.where(lake_effect_snow_event_id: params[:id])
    @bufkits.each do |buf|
        buf.destroy
    end

    @event = LakeEffectSnowEvent.where id: params[:id]
    redirect_to lake_effect_snow_event_url(@event)
  end

  def metar
    @metars = Metar.where(lake_effect_snow_event_id: params[:id])
    @metars.each do |met|
        met.destroy
    end
    @event = LakeEffectSnowEvent.where id: params[:id]
    redirect_to lake_effect_snow_event_url(@event)
  end

  # GET /lake_effect_snow_events or /lake_effect_snow_events.json
  def index
    @lake_effect_snow_events = LakeEffectSnowEvent.all
  end

  # GET /lake_effect_snow_events/1 or /lake_effect_snow_events/1.json
  def show
    begin
      @event = LakeEffectSnowEvent.find(params[:id])

      @radarStart = Bufkit.handleDate(@event.startDate, @event.startTime)
      @radarEnd = Bufkit.handleDate(@event.endDate, @event.endTime)

      @url = `python lib/assets/getRadar.py "#{@radarStart}" "#{@radarEnd}"`

      @snow_reports = SnowReport.where(lake_effect_snow_event_id: @event.id)
      @namBuf = Bufkit.where(lake_effect_snow_event_id: @event.id, modelType: "NAM")
      @rapBuf = Bufkit.where(lake_effect_snow_event_id: @event.id, modelType: "RAP")
      @metarCLE = Metar.where(lake_effect_snow_event_id: @event.id, site: "CLE")
      @metarERI = Metar.where(lake_effect_snow_event_id: @event.id, site: "ERI")
      @metarGKJ = Metar.where(lake_effect_snow_event_id: @event.id, site: "GKJ")

      @namBufCLE = @namBuf.where(station: "kcle")
      @namBufERI = @namBuf.where(station: "keri")
      @namBufGKJ = @namBuf.where(station: "kgkl").or(@namBuf.where(station: "kgkj"))
      @namBufLE1 = @namBuf.where(station: "le1")
      @namBufLE2 = @namBuf.where(station: "le2")

      @rapBufCLE = @rapBuf.where(station: "kcle")
      @rapBufERI = @rapBuf.where(station: "keri")
      @rapBufGKJ = @rapBuf.where(station: "kgkl").or(@namBuf.where(station: "kgkj"))
      @rapBufLE1 = @rapBuf.where(station: "le1")
      @rapBufLE2 = @rapBuf.where(station: "le2")

      @tableHeaderBuf = ["Model Type", "Station", "Time", 
        "925mb Temperature", "925mb Dew Point", "925mb Humidity", "925mb Humidity (Ice)","925mb Wind Direction", "925mb Wind Speed","925mb Height",
        "850mb Temperature", "850mb Dew Point", "850mb Humidity", "850mb Humidity (Ice)","850mb Wind Direction", "850mb Wind Speed","850mb Height",                             
        "700mb Temperature", "700mb Dew Point", "700mb Humidity", "850mb Humidity (Ice)","700mb Wind Direction", "700mb Wind Speed","700mb Height",
        "Model Cape", "Lake Induced Cape", "Lake Induced NCape", "Lake Induced EQL", "10M Wind Direction", "10M Wind Speed",
        "Bulk Shear", "Bulk Shear U", "Bulk Shear V", "Lake Surface to 850mb Temperature Difference", "Lake Surface to 700mb Temperature Difference"]
      rescue ActiveRecord::RecordNotFound => e
        redirect_to home_record_not_found_url
      end
  end


  # GET /lake_effect_snow_events/new
  def new
    @lake_effect_snow_event = LakeEffectSnowEvent.new
  end

  # GET /lake_effect_snow_events/1/edit
  def edit
    @bufkits = Bufkit.where(lake_effect_snow_event_id: @lake_effect_snow_event.id)
    @bufkits.each do |buf|
        buf.destroy
    end

    @metars = Metar.where(lake_effect_snow_event_id: @lake_effect_snow_event.id)
    @metars.each do |met|
        met.destroy
    end

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
    @snowReports = SnowReport.where(lake_effect_snow_event_id: @lake_effect_snow_event.id)
    @snowReports.each do |report|
        report.destroy
    end

    @bufkits = Bufkit.where(lake_effect_snow_event_id: @lake_effect_snow_event.id)
    @bufkits.each do |buf|
        buf.destroy
    end

    @metars = Metar.where(lake_effect_snow_event_id: @lake_effect_snow_event.id)
    @metars.each do |met|
        met.destroy
    end

    @lake_effect_snow_event.destroy

    respond_to do |format|
      format.html { redirect_to lake_effect_snow_events_url, notice: "Lake effect snow event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lake_effect_snow_event
      begin
        @lake_effect_snow_event = LakeEffectSnowEvent.find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
        redirect_to home_record_not_found_url
      end
    end

    # Only allow a list of trusted parameters through.
    def lake_effect_snow_event_params
      params.require(:lake_effect_snow_event).permit(:eventName, :startDate, :endDate, :peakStartDate, :peakEndDate, :startTime, :endTime, :peakStartTime, :peakEndTime, :averageLakeSurfaceTemperature)
    end
end
