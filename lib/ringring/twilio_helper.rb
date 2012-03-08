module Ringring
class TwilioHelper
  def self.send_sms(from, to, msg)
    to.each do |to_num|
      next if to_num.blank?
      $twilio_client.account.sms.messages.create(
        :from => from,
        :to => to_num,
        :body => msg
      )
    end
  end    

  def self.phone_all(from, to, url)
    to.each do |to_num|
      next if to_num.blank?
      $twilio_client.account.calls.create(
        :from => from,
        :to => to_num,
        :url => url
      )
    end
  end
end
end
