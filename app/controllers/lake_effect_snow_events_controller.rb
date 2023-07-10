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
    @model = params[:model]
    @site = params[:site]

    @sWindDirectionLow = (params[:sWindDirectionLow] =="" ? -1 : params[:sWindDirectionLow].to_i)
    @sWindDirectionHigh = (params[:sWindDirectionHigh] =="" ? -1 : params[:sWindDirectionHigh].to_i)
    @sWindSpeed = (params[:sWindSpeed] == "" ? -1 : params[:sWindSpeed].to_i)
    @nWindDirectionLow = (params[:nWindDirectionLow] =="" ? -1 : params[:nWindDirectionLow].to_i)
    @nWindDirectionHigh = (params[:nWindDirectionHigh] =="" ? -1 : params[:nWindDirectionHigh].to_i)
    @nWindSpeed = (params[:nWindSpeed] == "" ? -1 : params[:nWindSpeed].to_i)
    @eWindDirectionLow = (params[:eWindDirectionLow] =="" ? -1 : params[:eWindDirectionLow].to_i)
    @eWindDirectionHigh = (params[:eWindDirectionHigh] =="" ? -1 : params[:eWindDirectionHigh].to_i)
    @eWindSpeed = (params[:eWindSpeed] == "" ? -1 : params[:eWindSpeed].to_i)
    @sur850TempDiff = (params[:sur850TempDiff] == "" ? -1 : params[:sur850TempDiff].to_i)
    @sur700TempDiff = (params[:sur700TempDiff] == "" ? -1 : params[:sur700TempDiff].to_i)
    @cape = (params[:liCAPE] =="" ? -1 : params[:liCAPE].to_i)
    @ncape = (params[:liNCAPE] =="" ? -1 : params[:liNCAPE].to_i)
    @eql = (params[:liEQL] == "" ? -1 : params[:liEQL].to_i)
    @bulkShear = (params[:bulkShear] == "" ? -1 : params[:bulkShear].to_i)

    @eventIDs = []

    @surSpeedGraph = []
    @nineSpeedGraph = []
    @eightSpeedGraph = []
    @capeGraph = []
    @ncapeGraph = []
    @eqlGraph = []
    @delta850Graph = []
    @delta700Graph = []

    @allEvents = LakeEffectSnowEvent.all
    
    for event in @allEvents do

      @bufkits = get_bufkits(event)
 
      dataArray = [0, 0, 0, 0, 0, 0, 0, 0, 0]
      windArray = [[0, 0],[0, 0],[0, 0]]
      windDirections = [0.0, 0.0, 0.0]

      for bufkit in @bufkits do
        windArray[0][0] = windArray[0][0] + Math.sin(bufkit.tenMeterWindDirection*Math::PI/180)
        windArray[0][1] = windArray[0][1] + Math.cos(bufkit.tenMeterWindDirection*Math::PI/180)
        windArray[1][0] = windArray[1][0] + Math.sin(bufkit.lowWindDirection*Math::PI/180)
        windArray[1][1] = windArray[1][1] + Math.cos(bufkit.lowWindDirection*Math::PI/180)
        windArray[2][0] = windArray[2][0] + Math.sin(bufkit.medWindDirection*Math::PI/180)
        windArray[2][1] = windArray[2][1] + Math.cos(bufkit.medWindDirection*Math::PI/180)
        dataArray[0] = dataArray[0] + bufkit.tenMeterWindSpeed
        dataArray[1] = dataArray[1] + bufkit.lowWindSpeed
        dataArray[2] = dataArray[2] + bufkit.medWindSpeed
        dataArray[3] = dataArray[3] + bufkit.lowDeltaT
        dataArray[4] = dataArray[4] + bufkit.highDeltaT
        dataArray[5] = dataArray[5] + bufkit.lakeEffectCape
        dataArray[6] = dataArray[6] + bufkit.lakeEffectNCape
        dataArray[7] = dataArray[7] + bufkit.lakeEffectEQL
        dataArray[8] = dataArray[8] + bufkit.bulkShear

      end

      if @bufkits.length > 0

        for i in (0..windDirections.length-1) do
          windDirections[i] = ((Math.atan2(windArray[i][0], windArray[i][1])*180/Math::PI) % 360).round(1)
        end
        
        for i in (0..dataArray.length-1) do
          dataArray[i] = dataArray[i] / @bufkits.length
        end

        if ((@sWindDirectionLow != -1 && @sWindDirectionHigh != -1) && (windDirections[0] < (@sWindDirectionLow ) || windDirections[0] > (@sWindDirectionHigh))) then next end

        if ((@nWindDirectionLow != -1 && @nWindDirectionHigh != -1) && (windDirections[1] < (@nWindDirectionLow ) || windDirections[1] > (@nWindDirectionHigh))) then next end

        if ((@eWindDirectionLow != -1 && @eWindDirectionHigh != -1) && (windDirections[2] < (@eWindDirectionLow ) || windDirections[2] > (@eWindDirectionHigh))) then next end

        if (@sWindSpeed != -1 && (dataArray[0] < @sWindSpeed)) then next end

        if (@nWindSpeed != -1 && (dataArray[1] < @nWindSpeed)) then next end

        if (@eWindSpeed != -1 && (dataArray[2] < @eWindSpeed)) then next end

        if (@sur850TempDiff != -1 && (dataArray[3] < @sur850TempDiff)) then next end

        if (@sur700TempDiff != -1 && (dataArray[4] < @sur700TempDiff)) then next end

        if (@cape != -1 && (dataArray[5] < @cape)) then next end

        if (@ncape != -1 && (dataArray[6] < @ncape)) then next end

        if (@eql != -1 && (dataArray[7] < @eql))  then next end

        if (@bulkShear != -1 && (dataArray[8] < @bulkShear)) then next end

        @eventIDs.append(@bufkits[0].lake_effect_snow_event_id)
        @lakeEvent = LakeEffectSnowEvent.find(@bufkits[0].lake_effect_snow_event_id).eventName
        @surSpeedGraph.append([@lakeEvent, dataArray[0]])
        @nineSpeedGraph.append([@lakeEvent, dataArray[1]])
        @eightSpeedGraph.append([@lakeEvent, dataArray[2]])
        @delta850Graph.append([@lakeEvent, dataArray[3]])
        @delta700Graph.append([@lakeEvent, dataArray[4]])
        @capeGraph.append([@lakeEvent, dataArray[5]])
        @ncapeGraph.append([@lakeEvent, dataArray[6]])
        @eqlGraph.append([@lakeEvent, dataArray[7]])

      end
    end
    puts(@eventIDs)
    @results = LakeEffectSnowEvent.find(@eventIDs)

  end

  def advancedSearchResults
    @model = params[:model]
    @site = params[:site]

    @surfaceWindDirection = (params[:surfaceWindDirection] =="" ? -1 : params[:surfaceWindDirection].to_i)
    @surfaceWindSpeed = (params[:surfaceWindSpeed] == "" ? -1 : params[:surfaceWindSpeed].to_i)
    @nineWindDirection = (params[:nineWindDirection] =="" ? -1 : params[:nineWindDirection].to_i)
    @nineWindSpeed = (params[:nineWindSpeed] == "" ? -1 : params[:nineWindSpeed].to_i)
    @eightWindDirection = (params[:eightWindDirection] =="" ? -1 : params[:eightWindDirection].to_i)
    @eightWindSpeed = (params[:eightWindSpeed] == "" ? -1 : params[:eightWindSpeed].to_i)
    @sevenWindDirection = (params[:sevenWindDirection] =="" ? -1 : params[:sevenWindDirection].to_i)
    @sevenWindSpeed = (params[:sevenWindSpeed] == "" ? -1 : params[:sevenWindSpeed].to_i)
    @sur850TempDiff = (params[:sur850TempDiff] == "" ? -1 : params[:sur850TempDiff].to_i)
    @sur700TempDiff = (params[:sur700TempDiff] == "" ? -1 : params[:sur700TempDiff].to_i)
    @cape = (params[:liCAPE] =="" ? -1 : params[:liCAPE].to_i)
    @ncape = (params[:liNCAPE] =="" ? -1 : params[:liNCAPE].to_i)
    @eql = (params[:liEQL] == "" ? -1 : params[:liEQL].to_i)

    @eventResults = []

    @allEvents = LakeEffectSnowEvent.all
    
    for event in @allEvents do

      @surfaceClose = true
      @nineClose = true

      @bufkits = get_bufkits(event)
 
      puts(event.eventName)
      puts(@bufkits)

      dataArray = [0, 0, 0, 0, 0, 0, 0, 0, 0]
      windArray = [[0, 0],[0, 0],[0, 0], [0, 0]]
      windDirections = [0.0, 0.0, 0.0, 0.0]

      @score = 0
      @scoreArray = [4, 5, 4, 2, 0.25, 0.5, 0.5, 0.25, 3, 2, 3, 0.1, 0.01]

      for bufkit in @bufkits do
        windArray[0][0] = windArray[0][0] + Math.sin(bufkit.tenMeterWindDirection*Math::PI/180)
        windArray[0][1] = windArray[0][1] + Math.cos(bufkit.tenMeterWindDirection*Math::PI/180)
        windArray[1][0] = windArray[1][0] + Math.sin(bufkit.lowWindDirection*Math::PI/180)
        windArray[1][1] = windArray[1][1] + Math.cos(bufkit.lowWindDirection*Math::PI/180)
        windArray[2][0] = windArray[2][0] + Math.sin(bufkit.medWindDirection*Math::PI/180)
        windArray[2][1] = windArray[2][1] + Math.cos(bufkit.medWindDirection*Math::PI/180)
        windArray[3][0] = windArray[3][0] + Math.sin(bufkit.highWindDirection*Math::PI/180)
        windArray[3][1] = windArray[3][1] + Math.cos(bufkit.highWindDirection*Math::PI/180)
        dataArray[0] = dataArray[0] + bufkit.tenMeterWindSpeed
        dataArray[1] = dataArray[1] + bufkit.lowWindSpeed
        dataArray[2] = dataArray[2] + bufkit.medWindSpeed
        dataArray[3] = dataArray[3] + bufkit.highWindSpeed
        dataArray[4] = dataArray[4] + bufkit.lowDeltaT
        dataArray[5] = dataArray[5] + bufkit.highDeltaT
        dataArray[6] = dataArray[6] + bufkit.lakeEffectCape
        dataArray[7] = dataArray[7] + bufkit.lakeEffectNCape
        dataArray[8] = dataArray[8] + bufkit.lakeEffectEQL
      end

      if @bufkits.length > 0

        for i in (0..windDirections.length-1) do
          windDirections[i] = ((Math.atan2(windArray[i][0], windArray[i][1])*180/Math::PI) % 360).round(1)
        end
        
        for i in (0..dataArray.length-1) do
          dataArray[i] = dataArray[i] / @bufkits.length
        end
        
        if (@surfaceWindDirection != -1)
          if((windDirections[0]-@surfaceWindDirection.abs)>=15)
            @surfaceClose = false
          else
            @score = @score + (windDirections[0]-@surfaceWindDirection).abs*@scoreArray[0]
          end
        end
        
        if (@nineWindDirection != -1)
          if((windDirections[1]-@nineWindDirection.abs)>=15)
            @nineClose = false
          else
            @score = @score + (windDirections[1]-@nineWindDirection).abs*@scoreArray[1]
          end
          
        end

        if (@eightWindDirection != -1)
          @score = @score + (windDirections[2]-@eightWindDirection).abs*@scoreArray[2]
        end

        if (@sevenWindDirection != -1)
          @score = @score + (windDirections[3]-@sevenWindDirection).abs*@scoreArray[3]
        end
        
        if (@surfaceWindSpeed != -1)
          @score = @score + (dataArray[0]-@surfaceWindSpeed).abs*@scoreArray[4]
        end
  
        if (@nineWindSpeed != -1)
          @score = @score + (dataArray[1]-@nineWindSpeed).abs*@scoreArray[5]
        end
  
        if (@eightWindSpeed != -1)
          @score = @score + (dataArray[2]-@eightWindSpeed).abs*@scoreArray[6]
        end

        if (@sevenWindSpeed != -1)
          @score = @score + (dataArray[3]-@sevenWindSpeed).abs*@scoreArray[7]
        end
  
        if (@sur850TempDiff != -1)
          @score = @score + (dataArray[4]-@sur850TempDiff).abs*@scoreArray[8]
        end
  
        if (@sur700TempDiff != -1)
          @score = @score + (dataArray[5]-@sur700TempDiff).abs*@scoreArray[9]
        end
  
        if (@cape != -1)
          @score = @score + (dataArray[6]-@cape).abs*@scoreArray[10]
        end
  
        if (@ncape != -1)
          @score = @score + (dataArray[7]-@ncape).abs*@scoreArray[11]
        end
  
        if (@eql != -1)
          @score = @score + (dataArray[8]-@eql).abs*@scoreArray[12]
        end
      end
      if(@surfaceClose && @nineClose)
        @eventResults.append([event.id,event.eventName,@score.round(1)])
      end
    end
  end

  def pythonObservation
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

  def surface

    @surfaceObs = SurfaceObservations.where(lake_effect_snow_event_id: params[:id])
    @surfaceObs.each do |sur|
        sur.destroy
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
      if(@event.startDate.month < 10) then @month = "0"+ @month end

      @month2 = @event.endDate.month.to_s
      if(@event.endDate.month < 10) then @month2 = "0"+ @month2 end

      @day1 = @event.startDate.day.to_s
      if(@event.startDate.day < 10) then @day1 = "0"+@day1 end

      @day2 = @event.endDate.day.to_s
      if(@event.endDate.day < 10) then @day2 = "0"+@day2 end

      @hour1 = (@event.startTime - @event.startTime%3).to_s
      if(@hour1.length() < 2) then @hour1 = "0"+@hour1 end

      @durationDay = (@event.endDate - @event.startDate).to_i
      
      @hourDuration = 0
      if(@durationDay >=2)
        @hourDuration = 72
      else
        @hourDuration = (@durationDay+1)*24
      end

      @truncatedYear1 = @event.startDate.year.to_s[2,3]
      @truncatedYear2 = @event.endDate.year.to_s[2,3]
      @upperHour1 = "00"
      @upperHour2 = "12"
      if(@event.startTime >= 12) then  @upperHour1 = "12" end


      @snowfallURL = "https://www.nohrsc.noaa.gov/interactive/html/map.html?ql=station&zoom=&loc=42.174+N%2C+84.863+W&var=snowfall_"+@hourDuration.to_s+"_h&dy="+@event.endDate.year.to_s+"&dm="+@month2+"&dd="+@day2+"&dh=12&snap=1&o11=1&o10=1&o9=1&o12=1&o13=1&lbl=m&mode=pan&extents=us&min_x=-84.975000000002&min_y=39.758333333329&max_x=-79.200000000002&max_y=43.008333333329&coord_x=-82.087500000002&coord_y=41.383333333329&zbox_n=&zbox_s=&zbox_e=&zbox_w=&metric=0&bgvar=dem&shdvar=shading&width=800&height=450&nw=800&nh=450&h_o=0&font=0&js=1&uc=0"
      @surfaceAnalysisURL = "https://www.wpc.ncep.noaa.gov/archives/web_pages/sfc/sfc_archive_maps.php?arcdate="+@month+"/"+@day1+"/"+@event.endDate.year.to_s+"&selmap="+@event.endDate.year.to_s+@month+@day1+@hour1
      @upperAirAnalysisURL = "https://www.spc.noaa.gov/cgi-bin-spc/getuadata.pl?MyDate1="+@truncatedYear1+@month+@day1+"&Time1="+@upperHour1+"&MyDate2="+@truncatedYear2+@month2+@day2+"&Time2="+@upperHour2+"&align=V&Levels=925&Levels=850&Levels=700&Levels=500"


      if @day2 < @day1 then @day1 = "01" end

      @buffaloURL = "https://weather.uwyo.edu/cgi-bin/sounding?region=naconf&TYPE=GIF%3ASKEWT&YEAR="+@event.endDate.year.to_s+"&MONTH="+@month2+"&FROM="+@day1+"00&TO="+@day2+"00&STNM=72528"
      @detroitURL = "https://weather.uwyo.edu/cgi-bin/sounding?region=naconf&TYPE=GIF%3ASKEWT&YEAR="+@event.endDate.year.to_s+"&MONTH="+@month2+"&FROM="+@day1+"00&TO="+@day2+"00&STNM=72632"
      @radarURL = `python lib/assets/getRadar.py "#{@radarStart}" "#{@radarEnd}"`



      @vtecURL1 = ""
      @vtecURL2 = ""
      @vtecURL3 = ""
      @vtecURL4 = ""

      if @event.tecOne != nil
        @vtecURL1 = "https://mesonet.agron.iastate.edu/vtec/#"+@event.tecYearOne.to_s+"-O-NEW-KCLE-"+@event.tecOne
      end

      if @event.tecTwo != nil
        @vtecURL2 = "https://mesonet.agron.iastate.edu/vtec/#"+@event.tecYearTwo.to_s+"-O-NEW-KCLE-"+@event.tecTwo
      end

      if @event.tecThree != nil
        @vtecURL3 = "https://mesonet.agron.iastate.edu/vtec/#"+@event.tecYearThree.to_s+"-O-NEW-KCLE-"+@event.tecThree
      end

      if @event.tecFour != nil
        @vtecURL4 = "https://mesonet.agron.iastate.edu/vtec/#"+@event.tecYearFour.to_s+"-O-NEW-KCLE-"+@event.tecFour
      end
     
      @snow_reports = SnowReport.where(lake_effect_snow_event_id: @event.id)

      @namBuf = Bufkit.where(lake_effect_snow_event_id: @event.id, modelType: "NAM")
      @rapBuf = Bufkit.where(lake_effect_snow_event_id: @event.id, modelType: "RAP")

      @detroitObs = Observation.where(lake_effect_snow_event_id: @event.id, site: "Detroit")
      @buffaloObs = Observation.where(lake_effect_snow_event_id: @event.id, site: "Buffalo")

      @metars = Metar.where(lake_effect_snow_event_id: @event.id)
      @metarCLE = Metar.where(lake_effect_snow_event_id: @event.id, site: "CLE")
      @metarERI = Metar.where(lake_effect_snow_event_id: @event.id, site: "ERI")
      @metarGKJ = Metar.where(lake_effect_snow_event_id: @event.id, site: "GKJ")
      @metarBKL = Metar.where(lake_effect_snow_event_id: @event.id, site: "BKL")
      @metarCGF = Metar.where(lake_effect_snow_event_id: @event.id, site: "CGF")
      @metarLNN = Metar.where(lake_effect_snow_event_id: @event.id, site: "LNN")
      @metarHZY = Metar.where(lake_effect_snow_event_id: @event.id, site: "HZY")
      @metarYNG = Metar.where(lake_effect_snow_event_id: @event.id, site: "YNG")
      @metarPOV = Metar.where(lake_effect_snow_event_id: @event.id, site: "POV")
      @metarAKR = Metar.where(lake_effect_snow_event_id: @event.id, site: "AKR")
      @metarCAK = Metar.where(lake_effect_snow_event_id: @event.id, site: "CAK")
      @metarLPR = Metar.where(lake_effect_snow_event_id: @event.id, site: "LPR")

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
      
      @tableSurIDs = ['buffalo', 'detroit']
      @tableBufIDs = ['kcle', 'keri', 'kgkl', 'le1', 'le2', 'all']
      @tableMetIDs = ['cle', 'eri', 'gkj', 'bkl', 'cgf', 'lnn', 'hzy', 'yng', 'pov', 'akr', 'cak', 'lpr', 'all']
      @tableNAM = [@namBufCLE, @namBufERI, @namBufGKJ, @namBufLE1, @namBufLE2, @namBuf]
      @tableRAP = [@rapBufCLE, @rapBufERI, @rapBufGKJ, @rapBufLE1, @rapBufLE2, @rapBuf]
      @tableMET = [@metarCLE, @metarERI, @metarGKJ, @metarBKL, @metarCGF, @metarLNN, @metarHZY, @metarYNG, @metarPOV, @metarAKR, @metarCAK, @metarLPR, @metars]
      @tableSUR = [@buffaloObs, @detroitObs]


      @tableHeaderSur = ["Site","Date", "Surface Pressure", "Surface Temperature", "Surface Dew Point", "Surface Humidity", "Surface Wind Direction", "Surface Wind Speed", "Surface Height",
        "925mb Pressure", "925mb Temperature", "925mb Dew Point", "925mb Humidity", "925mb Wind Direction", "925mb Wind Speed", "925mb Height",
        "850mb Pressure", "850mb Temperature", "850mb Dew Point", "850mb Humidity", "850mb Wind Direction", "850mb Wind Speed", "850mb Height",
        "700mb Pressure", "700mb Temperature", "700mb Dew Point", "700mb Humidity", "700mb Wind Direction", "700mb Wind Speed", "700mb Height"]

      @tableHeaderMet = ["Site", "Observation Time", "Temperature", "Dew Point", "Humidity", "Wind Direction", "Wind Speed", "MSLP", 
        "Visibility", "Wind Gust", "Present Weather", "Peak Wind Gust", "Peak Wind Direction", "Peak Wind Time"]

      @tableHeaderBuf = ["Model Type", "Station", "Time (Z)", 
        "925mb Temperature", "925mb Dew Point", "925mb Humidity", "925mb Humidity (Ice)","925mb Wind Direction", "925mb Wind Speed","925mb Height",
        "850mb Temperature", "850mb Dew Point", "850mb Humidity", "850mb Humidity (Ice)","850mb Wind Direction", "850mb Wind Speed","850mb Height",                             
        "700mb Temperature", "700mb Dew Point", "700mb Humidity", "850mb Humidity (Ice)","700mb Wind Direction", "700mb Wind Speed","700mb Height",
        "Model Cape", "Lake Induced Cape", "Lake Induced NCape", "Lake Induced EQL", "10M Wind Direction", "10M Wind Speed", "Bulk Shear Surface-700mb", 
        "Bulk Shear U", "Bulk Shear V", "Lake Surface-850mb ΔT", "Lake Surface-700mb ΔT", "Max Omega?", "Time (Z)"]
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
    
    @surObs = Observation.where(lake_effect_snow_event_id: @lake_effect_snow_event.id)
    @surObs.each do |ob|
        ob.destroy
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

    @surfaceObs = Observation.where(lake_effect_snow_event_id: @lake_effect_snow_event.id)
    @surfaceObs.each do |sur|
      sur.destroy
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
      params.require(:lake_effect_snow_event).permit(:eventName, :startDate, :endDate, :peakStartDate, :peakEndDate, :startTime, :endTime, :peakStartTime, :peakEndTime, :averageLakeSurfaceTemperature, :eventType, :tecOne, :tecTwo, :tecThree, :tecFour, :tecYearOne, :tecYearTwo, :tecYearThree, :tecYearFour)
    end

    def get_bufkits(event)
      @month1 = event.peakStartDate.month.to_s
      @month2 = event.peakEndDate.month.to_s
      @day1 = event.peakStartDate.day.to_s
      @day2 = event.peakEndDate.day.to_s


      @newStartHour = event.peakStartTime.to_s
      if (event.peakStartTime<10)
        @newStartHour = "0"+@newStartHour
      end

      @newEndHour = event.peakEndTime.to_s
      if (event.peakEndTime<10)
        @newEndHour = "0"+@newEndHour
      end

      @psTime = event.peakStartDate.to_s+" "+@newStartHour
      @peTime = event.peakEndDate.to_s+" "+@newEndHour

      puts(@psTime)
      puts(@peTime)
      puts("2021-01-18 09">= @psTime)
      puts("2021-01-18 09"<=@peTime)
      
      if(@site == "kgkj")
        @bufkits = Bufkit.where(lake_effect_snow_event: event.id).where(modelType: @model)
        @bufkits = @bufkits.where(station: "kgkj").or(@bufkits.where(station:"kgkl"))
        @bufkits = @bufkits.where("date <= ?", @peTime).where("date >= ?", @psTime)
        return @bufkits
      else 
        @bufkits = Bufkit.where(lake_effect_snow_event: event.id).where(modelType: @model).where(station: @site).where("date <= ?", @peTime).where("date >= ?", @psTime)
        return @bufkits
      end

    end
end
