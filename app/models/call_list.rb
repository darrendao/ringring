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

  private
  def must_have_owners
    if call_list_owners.empty?
      errors.add(:call_list_owners, "must be specified")
    end
  end
end
