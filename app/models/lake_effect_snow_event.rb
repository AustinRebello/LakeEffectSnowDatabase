class LakeEffectSnowEvent < ActiveRecord::Base
    has_many :bufkits
    has_many :metars
    has_many :snow_reports
    has_many :observastions
    validates :startDate, presence: true
    validates :endDate, presence: true
    validates :startTime, presence: true
    validates :endTime, presence: true
    validates :peakStartDate, presence: true
    validates :peakEndDate, presence: true
    validates :peakStartTime, presence: true
    validates :peakEndTime, presence: true
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
    validate :validate_peak_start_time_within_bounds
    validate :validate_peak_end_time_within_bounds
    validate :validate_start_time_within_bounds
    validate :validate_end_time_within_bounds

    def validate_peak_start_time_after_event_start_time
        errors.add(:peakStartDate.to_s.titleize, "must begin after start time") unless ((startDate < peakStartDate)or(peakStartTime>=startTime))
    end

    def validate_peak_end_time_before_event_end_time
        errors.add(:peakEndDate.to_s.titleize, "must begin before end time") unless ((endDate > peakEndDate)or(peakEndTime<=endTime))
    end
    
    def validate_peak_start_time_before_peak_end_time
        errors.add(:peakStartTime.to_s.titleize, "must begin before peak end time") unless ((peakEndDate > peakStartDate)or(peakEndTime>peakStartTime))
    end

    def validate_start_time_within_bounds
        errors.add(:startTime.to_s.titleize, "must be between 0Z and 23Z") unless ((startTime >= 0 )and(startTime<24))
    end

    def validate_peak_start_time_within_bounds
        errors.add(:peakStartTime.to_s.titleize, "must be between 0Z and 23Z") unless ((peakStartTime >= 0 )and(peakStartTime<24))
    end

    def validate_end_time_within_bounds
        errors.add(:endTime.to_s.titleize, "must be between 0Z and 23Z") unless ((endTime >= 0 )and(endTime<24))
    end

    def validate_peak_end_time_within_bounds
        errors.add(:peakEndTime.to_s.titleize, "must be between 0Z and 23Z") unless ((peakEndTime >= 0 )and(peakEndTime<24))
    end


end
