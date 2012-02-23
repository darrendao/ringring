class CallList < ActiveRecord::Base
  has_many :call_escalations
  has_many :call_list_owners
  has_many :owners, :through => :call_list_owners, :source => :user
  has_many :assignees, :through => :call_escalations, :source => :user
  accepts_nested_attributes_for :call_list_owners, :allow_destroy => true
end
