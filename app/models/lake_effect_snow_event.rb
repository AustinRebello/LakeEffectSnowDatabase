class LakeEffectSnowEvent < ActiveRecord::Base
    has_many :bufkits, dependent: :delete_all
    has_many :metars, dependent: :delete_all
    has_many :snow_reports, dependent: :delete_all
end
