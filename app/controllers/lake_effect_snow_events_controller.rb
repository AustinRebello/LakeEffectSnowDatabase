class LakeEffectSnowEventsController < ApplicationController
  before_action :set_lake_effect_snow_event, only: %i[ show edit update destroy ]
  

  def report
    @snowReports = SnowReport.where(lake_effect_snow_event_id: params[:id])
    @snowReports.each do |report|
        report.destroy
    end
    @event = LakeEffectSnowEvent.find(params[:id])
    redirect_to lake_effect_snow_event_url(@event)
  end

  def searchResults

    #condition ? if_true : if_false
    @model = params[:model]
    @site = params[:site]

    @windDirection = (params[:surWindDirection] =="" ? -1 : params[:surWindDirection].to_i)
    @windSpeed = (params[:surWindSpeed] == "" ? -1 : params[:surWindSpeed].to_i)
    @sur850TempDiff = (params[:sur850TempDiff] == "" ? -1 : params[:sur850TempDiff].to_i)
    @sur700TempDiff = (params[:sur700TempDiff] == "" ? -1 : params[:sur700TempDiff].to_i)
    @cape = params[:liCAPE].to_i
    @ncape = params[:liNCAPE].to_i
    @eql = params[:liEQL].to_i

    @eventIDs = []

    @allEvents = LakeEffectSnowEvent.all
    
    for event in @allEvents do

      @windCheck = true
      @speedCheck = true
      @lowTempCheck = true
      @highTempCheck = true
      @capeCheck = true
      @ncapeCheck = true
      @eqlCheck = true


      @month1 = event.peakStartDate.month.to_s
      @month2 = event.peakEndDate.month.to_s
      @day1 = event.peakStartDate.day.to_s
      @day2 = event.peakEndDate.day.to_s

      if event.peakStartDate.month < 10
        @month1 = "0"+@month1
      end

      if event.peakEndDate.month < 10
        @month2 = "0"+@month2
      end

      if event.peakStartDate.day < 10
        @day1 = "0"+@day1
      end

      if event.peakEndDate.day < 10
        @day2 = "0"+@day2
      end

      @psTime = event.peakStartDate.year.to_s+"-"+@month1+"-"+@day1+" "+event.peakStartTime.to_s
      @peTime = event.peakEndDate.year.to_s+"-"+@month2+"-"+@day2+" "+event.peakEndTime.to_s

      #@xyz = @xyz.where(id: params[:id]) if params[:id].present?
      
      @bufkits = Bufkit.where(lake_effect_snow_event: event.id).where(modelType: @model).where(station: @site).where("date <= ?", @peTime).where("date >= ?", @psTime)
      #@bufkits = @bufkit.where("tenMeterWindDirection > ?", params[:surWindDirection]-5) if params[:surWindDirection].present?
      #@bufkits = @bufkit.where("tenMeterWindDirection < ?", params[:surWindDirection]+5) if params[:surWindDirection].present?
      
      dataArray = [0,0,0,0]

      for bufkit in @bufkits do
        dataArray[0] = dataArray[0] + bufkit.tenMeterWindDirection
        dataArray[1] = dataArray[1] + bufkit.tenMeterWindSpeed
        dataArray[2] = dataArray[2] + bufkit.lowDeltaT
        dataArray[3] = dataArray[3] + bufkit.highDeltaT
      end

      if @bufkits.length > 0
        index = 0
        while index < dataArray.length do
          dataArray[index] = dataArray[index] / @bufkits.length
          index = index + 1
        end

        if @windDirection != -1 && (dataArray[0] < (@windDirection - 1) || dataArray[0] > (@windDirection + 1))
          @windCheck = false
        end
        if @windSpeed != -1 && (dataArray[1] < (@windSpeed - 5) || dataArray[1] > (@windSpeed + 5))
          @speedCheck = false
        end

        if(@windCheck && @speedCheck && @lowTempCheck && @highTempCheck && @capeCheck && @ncapeCheck && @eqlCheck)
          @eventIDs.append(@bufkits[0].lake_effect_snow_event_id)
        end

      end
    end
    puts(@eventIDs)
    @results = LakeEffectSnowEvent.find(@eventIDs)

  end

  def bufkit
    @bufkits = Bufkit.where(lake_effect_snow_event_id: params[:id])
    @bufkits.each do |buf|
        buf.destroy
    end

    @event = LakeEffectSnowEvent.find(params[:id])
    redirect_to lake_effect_snow_event_url(@event)
  end

  def metar

    @metars = Metar.where(lake_effect_snow_event_id: params[:id])
    @metars.each do |met|
        met.destroy
    end
    @event = LakeEffectSnowEvent.find(params[:id])
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

      @month = @event.startDate.month.to_s
      if(@event.startDate.month < 10)
        @month = "0"+ @month
      end

      @day1 = @event.startDate.day.to_s
      if(@event.startDate.day < 10)
        @day1 = "0"+@day1
      end

      @day2 = @event.endDate.day.to_s
      if(@event.endDate.day < 10)
        @day2 = "0"+@day2
      end

      @buffaloURL = "https://weather.uwyo.edu/cgi-bin/sounding?region=naconf&TYPE=TEXT%3ALIST&YEAR="+@event.startDate.year.to_s+"&MONTH="+@month+"&FROM="+@day1+"00&TO="+@day2+"00&STNM=72528"
      @detroitURL = "https://weather.uwyo.edu/cgi-bin/sounding?region=naconf&TYPE=TEXT%3ALIST&YEAR="+@event.startDate.year.to_s+"&MONTH="+@month+"&FROM="+@day1+"00&TO="+@day2+"00&STNM=72632"
      @radarURL = `python lib/assets/getRadar.py "#{@radarStart}" "#{@radarEnd}"`

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
