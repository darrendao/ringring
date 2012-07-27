class CallList < ActiveRecord::Base
  after_save :add_call_list_membership
  validates :name, :uniqueness => true, :presence => true
  validate :must_have_owners

  has_many :call_list_owners, :dependent => :destroy
  has_many :owners, :through => :call_list_owners, :source => :user
  accepts_nested_attributes_for :call_list_owners, :allow_destroy => true,
                                                   :reject_if => :all_blank

  has_many :call_escalations, :dependent => :destroy
  has_many :escalations, :through => :call_escalations, :source => :user

  has_one :call_list_calendar
  accepts_nested_attributes_for :call_list_calendar, :allow_destroy => true

  has_many :oncall_assignments, :dependent => :destroy
  has_many :oncalls, :through => :oncall_assignments, :source => :user

  has_one :error_notification, :as => :notifiable

  has_many :business_hours, :dependent => :destroy
  accepts_nested_attributes_for :business_hours, :allow_destroy => true,
                                                 :reject_if => :all_blank

  has_many :smart_contact_lists, :dependent => :destroy
  accepts_nested_attributes_for :smart_contact_lists, :allow_destroy => true,
                                                      :reject_if => :all_blank

  has_many :call_list_memberships, :dependent => :destroy
  has_many :members, :through => :call_list_memberships, :source => :user

  has_one :oncall_assignments_gen, :dependent => :destroy
  accepts_nested_attributes_for :oncall_assignments_gen, :allow_destroy => true

  def oncall_candidates
    call_list_memberships.where(:oncall_candidate => true)
  end

  def sorted_memberships
    call_list_memberships.sort{|x,y| x.user.username <=> y.user.username}
  end
  
  def owners_names
    owners.map{|o|o.username}
  end

  def escalation_names
    escalations.map{|o|o.username}
  end

  # List of users to send notifications to when something is wrong.
  # Should be a combination of the users in the owners and escalations list
  def notification_users
     [owners, escalations].compact.flatten.uniq
  end

  def in_business_hours?
    return false if business_hours.nil? or business_hours.empty?

    now = Time.now
    date = Date.today
    business_hours.each do |business_hour|
      next if business_hour.wday != date.wday
      Rails.logger.info business_hour.start_time.to_s
      Rails.logger.info Time.parse(business_hour.start_time.to_s)

      return false if business_hour.start_time.nil? or business_hour.end_time.nil?

      return true if Time.parse(business_hour.start_time.strftime("%H:%M")) <= now &&  now <= Time.parse(business_hour.end_time.strftime("%H:%M"))
    end
    return false
  end

  def current_oncalls
    [] | self.oncall_assignments.where("starts_at < ? AND ends_at > ?", DateTime.now, DateTime.now) | self.oncall_assignments.where("starts_at is NULL AND ends_at is NULL")
  end

  def contact_types
    smart_contact_lists.map{|list| list.contact_type}
  end

  def biz_hr_smart_contact_lists
    smart_contact_lists.where(:hour_type => "business_hour")
  end

  def off_hr_smart_contact_lists
    smart_contact_lists.where(:hour_type => "off_hour")
  end

  def smart_contacts
    results = []
    if in_business_hours?
      current_smart_contact_lists = biz_hr_smart_contact_lists
    else
      current_smart_contact_lists = off_hr_smart_contact_lists
    end
    current_smart_contact_lists.map{|list| list.contact_type}.each do |contact_type|
      case contact_type
      when "group_email"
        results << email unless email.empty?
      when "member_emails"
        results |=  members.map{|member| member.email unless member.on_vacation?}        
      when "member_sms"
        results |=  members.map{|member| member.sms_email unless member.on_vacation?}        
      when "oncall_emails"
        results |=  current_oncalls.map{|oncall| oncall.user.email}        
      when "oncall_sms"
        results |=  current_oncalls.map{|oncall| oncall.user.sms_email}        
      end 
    end
    results.compact
  end

  def gen_oncall_assignments
    raise "Need to enable automatic oncall assignments feature" unless oncall_assignments_gen && oncall_assignments_gen.enable == true
    raise "No available oncall candidate" if oncall_candidates.blank?

    oncall_candidates_enum = oncall_candidates.cycle
    start_date = oncall_assignments_gen.last_gen || Time.now
    end_date = Ringring::OncallAssignmentsGenerator::next_oncall_cycle(start_date, oncall_assignments_gen.cycle_day)
    end_date = end_date.change(:hour => oncall_assignments_gen.cycle_time.hour, :min => oncall_assignments_gen.cycle_time.min)
    end_date -= oncall_assignments_gen.timezone_offset if end_date.utc_offset == 0

    # Find the last person oncall. Then start with the next person
    counter = 0
    begin
      oncall_candidate = oncall_candidates_enum.next
      logger.info "#{oncall_candidate.inspect} vs #{last_oncall(start_date).inspect}"
      if last_oncall(start_date) == oncall_candidate.user
        break 
      end
   
      counter += 1
    end until counter >= oncall_candidates.size

    # Generate up to 4 weeks from now
    while start_date < AppConfig.oncall_assignments_gen['from_now'].weeks.from_now
      oncall_candidate = oncall_candidates_enum.next
      oncall_assignment = OncallAssignment.new(:user_id => oncall_candidate.user.id, :call_list_id => id, :starts_at => start_date, :ends_at => end_date)
      oncall_assignment.save
      oncall_assignments_gen.last_gen = end_date
      oncall_assignments_gen.save
      start_date = oncall_assignments_gen.last_gen
      end_date = Ringring::OncallAssignmentsGenerator::next_oncall_cycle(start_date, oncall_assignments_gen.cycle_day)
    end
  end

  private
  def must_have_owners
    if call_list_owners.empty?
    #if owners.empty?
      errors.add(:call_list_owners, "must be specified")
    end
  end

  def add_call_list_membership
    owners.each do |owner|
      CallListMembership.find_or_create_by_call_list_id_and_user_id(self.id, owner.id)
    end
  end

  # Given a date, find the last person oncall
  def last_oncall(date, exclusive=false)
    last_oncall_assignment = CallList.find(1).oncall_assignments.where('starts_at <= ?', Time.now).order('ends_at').last
    if last_oncall_assignment
      return last_oncall_assignment.user
    else
      return nil
    end
  end
end
