class PhoneNumberInfo < ActiveRecord::Base
  belongs_to :user
#  validates :sms_gateway, :presence => true if AppConfig.require_sms_gateway
#  validates :number, :presence => true if AppConfig.require_sms_gateway

  # Haven't found a good way to lookup sms gateway. Using whitepages api, I can lookup
  # the carrier, but that info doesn't seem updated. Some Verizon mobile shows up as Pacific
  # Bell landline
  #after_save :discover_sms_gateway

  def sms_email
    ret = nil
    unless number.blank? or sms_gateway.blank?
      ret = "#{number}@#{sms_gateway}"
    end
    ret
  end

  def discover_sms_gateway
    return if !sms_gateway.blank?
    phone_lookup = Ringring::PhoneLookup::Whitepages.new(AppConfig.whitepages_conf_file)
    carrier = phone_lookup.carrier_of(number)
    phone_carrier = PhoneCarrier.where(:name => carrier)
    return if phone_carrier.empty?
    self.sms_gateway = phone_carrier.sms_gateway
  end
end
