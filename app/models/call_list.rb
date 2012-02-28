class CallList < ActiveRecord::Base
  validates :name, :uniqueness => true

  has_many :call_list_owners
  has_many :owners, :through => :call_list_owners, :source => :user

  has_many :call_escalations
  has_many :escalations, :through => :call_escalations, :source => :user
  accepts_nested_attributes_for :call_list_owners, :allow_destroy => true

  has_one :call_list_calendar
  accepts_nested_attributes_for :call_list_calendar, :allow_destroy => true

  has_many :oncall_assignments
  has_many :oncalls, :through => :oncall_assignments, :source => :user

  def owners_names
    owners.map{|o|o.username}
  end

  def escalation_names
    escalations.map{|o|o.username}
  end

  def oncall_names
    oncalls.map{|o|o.username}
  end
end
