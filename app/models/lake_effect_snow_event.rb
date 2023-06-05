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

end
