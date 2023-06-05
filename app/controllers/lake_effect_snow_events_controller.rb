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


  # GET /lake_effect_snow_events or /lake_effect_snow_events.json
  def index
    @lake_effect_snow_events = LakeEffectSnowEvent.all
  end

  # GET /lake_effect_snow_events/1 or /lake_effect_snow_events/1.json
  def show

    @event = LakeEffectSnowEvent.find(params[:id])
    @snow_reports = SnowReport.where(lake_effect_snow_event_id: @event.id)
    @namBuf = Bufkit.where(lake_effect_snow_event_id: @event.id).where(modelType: "NAM")
    @rapBuf = Bufkit.where(lake_effect_snow_event_id: @event.id).where(modelType: "RAP")
    @metar = Metar.where(lake_effect_snow_event_id: @event.id)
  
    respond_to do |format|
      format.html
      format.csv { send_data Bufkit.downloadBUF(params[:id], params[:modelType]), filename: "#{params[:modelType]}-_EVENT_DATA-#{@event.eventName}.csv"}
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
