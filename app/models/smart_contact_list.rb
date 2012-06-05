class SmartContactList < ActiveRecord::Base
  belongs_to :call_list
  CONTACT_TYPES = ['group_email', 'member_emails', 'member_sms', 'oncall_emails', 'oncall_sms']
end
