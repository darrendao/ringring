class PhoneNumberInfo < ActiveRecord::Base
  belongs_to :user
  def sms_email
    ret = nil
    unless number.blank? or sms_gateway.blank?
      ret = "#{number}@#{sms_gateway}"
    end
    ret
  end
end
