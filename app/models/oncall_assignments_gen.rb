class OncallAssignmentsGen < ActiveRecord::Base
  belongs_to :call_list
  after_initialize :default_values

  def formatted_timezone_offset
    offset =  self.timezone_offset || 0
    ActiveSupport::TimeZone[offset/3600].formatted_offset(false)
  end

  private
  def default_values
    self.cycle_day ||= Date::ABBR_DAYNAMES.index('Mon') 
    #self.cycle_time ||= Time.parse(AppConfig.business_hours[0])
  end
end
