class CallEscalation < ActiveRecord::Base
  after_save :add_call_list_membership
  belongs_to :user
  belongs_to :call_list
  default_scope :order => 'position'
  validates :retry, :numericality => {:only_integer => true, :greater_than => 0}, :presence => true
  validate :user_has_phone_and_sms_info

  after_initialize :default_values

  private
  def default_values
    self.retry ||= AppConfig.default_retry || 2
  end
  def user_has_phone_and_sms_info
    if user.phone_number_info.blank? or user.phone_number_info.number.blank? or user.sms_email.blank?
      errors.add(:phone_number_info, "is missing phone number and/or sms email")
    end
  end
  def add_call_list_membership
    CallListMembership.find_or_create_by_call_list_id_and_user_id(call_list.id, user.id)
  end
end
