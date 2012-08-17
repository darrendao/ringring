class OncallAssignment < CallEscalation
  set_table_name 'oncall_assignments'
  validate :check_oncall_datetime
  after_save :add_call_list_membership

  def as_json(options = {})
    {
      :id => "#{self.id}_oncall_assignment",
      :title => self.user.username + " oncall",
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
  def user_has_phone_and_sms_info
    if user.phone_number_info.blank? or user.phone_number_info.number.blank? or user.sms_email.blank?
      errors.add(:phone_number_info, "is missing phone number and/or sms email")
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
  def add_call_list_membership
    membership = CallListMembership.find_or_create_by_call_list_id_and_user_id(call_list.id, user.id)
    membership.oncall_candidate = true
    membership.save
  end
end
