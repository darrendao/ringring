class OncallAssignment < ActiveRecord::Base
  belongs_to :user
  belongs_to :call_list
  default_scope :order => 'position'
  validates :retry, :numericality => {:only_integer => true, :greater_than => 0}, :presence => true
  validate :user_has_phone_and_sms_info, :check_oncall_datetime

  after_initialize :default_values

#  skip_time_zone_conversion_for_attributes << :starts_at
#  skip_time_zone_conversion_for_attributes << :ends_at

  def as_json(options = {})
    {
      :id => self.id,
      :title => self.user.username,
      :description => "description",
      :start => starts_at.iso8601,
      :end => ends_at.iso8601,
      :allDay => false,
      :recurring => false,
      :url => Rails.application.routes.url_helpers.call_list_oncall_assignment_path(self.call_list, id)
    }
  end

  def starts_at_local
    localize_time(starts_at, timezone_offset)    
  end
  def ends_at_local
    localize_time(ends_at, timezone_offset)
  end

  private
  def default_values
    self.retry ||= AppConfig.default_retry || 2
  end
  def user_has_phone_and_sms_info
    if user.phone_number_info.blank? or user.phone_number_info.number.blank? or user.phone_number_info.sms_gateway.blank?
      errors.add(:phone_number_info, "is missing phone number and/or sms gateway")
    end
  end
  def check_oncall_datetime
    if starts_at.blank? ^ ends_at.blank?
      errors.add(:starts_at, "and ends_at both need to be specified.")
    end
    if starts_at && ends_at && starts_at > ends_at
      errors.add(:starts_at, "cannot be after ends_at")
    end
  end
  def localize_time(time, offset)
    return time unless offset
    local_zone = nil
    ActiveSupport::TimeZone.us_zones.each do |zone|
      if offset == zone.period_for_utc(time).utc_total_offset
        local_zone = zone
        break
      end
    end
    if local_zone
      return time.in_time_zone(local_zone)
    else
      return time
    end
  end
end
