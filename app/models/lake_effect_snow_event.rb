class LakeEffectSnowEvent < ActiveRecord::Base
    has_many :bufkits#, dependent: :destroy
    has_many :metars#, dependent: :destroy
    has_many :snow_reports#, dependent: :destroy
    validates :startDate, presence: true
    validates :endDate, presence: true
    validates :startTime, presence: true
    validates :endTime, presence: true
    validates :averageLakeSurfaceTemperature, presence: true
    validates :startDate, comparison: { less_than_or_equal_to: :endDate}
    validates :startDate, comparison: { less_than_or_equal_to: :peakEndDate}
    validates :peakStartDate, comparison: { less_than_or_equal_to: :peakEndDate}
    validates :peakEndDate, comparison: { less_than_or_equal_to: :endDate}
    validates :startDate, comparison: {less_than_or_equal_to: Date.today}
    validates :endDate, comparison: {less_than_or_equal_to: Date.today}
    validates :peakStartDate, comparison: {less_than_or_equal_to: Date.today}
    validates :peakEndDate, comparison: {less_than_or_equal_to: Date.today}
    validate :validate_peak_start_time_after_event_start_time
    validate :validate_peak_end_time_before_event_end_time
    validate :validate_peak_start_time_before_peak_end_time

    def validate_peak_start_time_after_event_start_time
        errors.add(:peakStartDate.to_s.titleize, "must begin after start time") unless ((startDate < peakStartDate)or(peakStartTime>=startTime))
    end

    def validate_peak_end_time_before_event_end_time
        errors.add(:peakEndDate.to_s.titleize, "must begin before end time") unless ((endDate > peakEndDate)or(peakEndTime<=endTime))
    end
    
    def validate_peak_start_time_before_peak_end_time
        errors.add(:peakStartTime.to_s.titleize, "must begin before peak end time") unless ((peakEndDate > peakStartDate)or(peakEndTime>peakStartTime))
    end


end
