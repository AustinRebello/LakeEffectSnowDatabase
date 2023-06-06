class SnowReportsController < ApplicationController
  before_action :set_snow_report, only: %i[ show edit update destroy ]

  def file
    @event = LakeEffectSnowEvent.find(params[:event_id])

    @snowReports = SnowReport.where(lake_effect_snow_event_id: @event.id)
    @snowReports.each do |report|
        report.destroy
    end

  end

  def import

    @file = params[:file]
    @event = LakeEffectSnowEvent.find(params[:event_id])
    @eventID = @event.id
    SnowReport.import(@file, @eventID)
    redirect_to lake_effect_snow_event_url(@event)
end

def downloadCSV
  @event = LakeEffectSnowEvent.find(params[:event_id])
  respond_to do |format|
    format.html
    format.csv { send_data SnowReport.downloadBUF(params[:event_id]), filename: "SNOW_REPORT_EVENT_DATA-#{@event.eventName}.csv"}
  end
end

  # GET /snow_reports or /snow_reports.json
  def index
    @snow_reports = SnowReport.all
  end

  # GET /snow_reports/1 or /snow_reports/1.json
  def show
  end


  # GET /snow_reports/new
  def new
    @snow_report = SnowReport.new
    @lake_effect_snow_events = LakeEffectSnowEvent.all
  end

  # GET /snow_reports/1/edit
  def edit
  end

  # POST /snow_reports or /snow_reports.json
  def create
    @snow_report = SnowReport.new(snow_report_params)
    @lake_effect_snow_events = LakeEffectSnowEvent.all

    respond_to do |format|
      if @snow_report.save
        format.html { redirect_to snow_report_url(@snow_report), notice: "Snow report was successfully created." }
        format.json { render :show, status: :created, location: @snow_report }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @snow_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /snow_reports/1 or /snow_reports/1.json
  def update
    respond_to do |format|
      if @snow_report.update(snow_report_params)
        format.html { redirect_to snow_report_url(@snow_report), notice: "Snow report was successfully updated." }
        format.json { render :show, status: :ok, location: @snow_report }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @snow_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /snow_reports/1 or /snow_reports/1.json
  def destroy
    @snow_report.destroy

    respond_to do |format|
      format.html { redirect_to snow_reports_url, notice: "Snow report was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_snow_report
      @snow_report = SnowReport.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def snow_report_params
      params.require(:snow_report).permit(:lastName, :city, :latitude, :longitude, :stormTotal, :lake_effect_snow_event_id)
    end
end
