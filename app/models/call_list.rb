class CallList < ActiveRecord::Base
  validates :name, :uniqueness => true, :presence => true
  validate :must_have_owners

  has_many :call_list_owners
  has_many :owners, :through => :call_list_owners, :source => :user

  has_many :call_escalations
  has_many :escalations, :through => :call_escalations, :source => :user
  accepts_nested_attributes_for :call_list_owners, :allow_destroy => true,
                                                   :reject_if => :all_blank

  has_one :call_list_calendar
  accepts_nested_attributes_for :call_list_calendar, :allow_destroy => true

  has_many :oncall_assignments
  has_many :oncalls, :through => :oncall_assignments, :source => :user

  has_one :error_notification, :as => :notifiable

  has_many :business_hours
  accepts_nested_attributes_for :business_hours, :allow_destroy => true,
                                                   :reject_if => :all_blank
  
  def owners_names
    owners.map{|o|o.username}
  end

  def escalation_names
    escalations.map{|o|o.username}
  end

  def oncall_names
    oncalls.map{|o|o.username}
  end

  # List of users to send notifications to when something is wrong.
  # Should be a combination of the users in the owners and escalations list
  def notification_users
     [owners, escalations].compact.flatten.uniq
  end

  def in_business_hours?
Rails.logger.info "HELLLLO"
    return false if business_hours.nil? or business_hours.empty?

    now = Time.now
    date = Date.today
    business_hours.each do |business_hour|
Rails.logger.info "HELLLLO    #{business_hour.wday}"
      next if business_hour.wday != date.wday
      Rails.logger.info business_hour.start_time.to_s
      Rails.logger.info Time.parse(business_hour.start_time.to_s)

      return true if Time.parse(business_hour.start_time.strftime("%H:%M")) <= now &&  now <= Time.parse(business_hour.end_time.strftime("%H:%M"))
    end
    return false
  end

  private
  def must_have_owners
    if call_list_owners.empty?
      errors.add(:call_list_owners, "must be specified")
    end
  end
end
