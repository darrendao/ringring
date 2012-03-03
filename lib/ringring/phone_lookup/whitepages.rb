module Ringring::PhoneLookup
class Whitepages
  def initialize(conf_file)
    @conf = YAML.load_file(conf_file)
  end
  def carrier_of(phone_number)
    url = "#{@conf['api_url']}/?phone=#{phone_number};api_key=#{@conf['api_key']};outputtype=JSON"
    result = JSON.parse(RestClient.get(url).body)
    result['listings'].each do |listing|
      listing['phonenumbers'].each do |number|
        return number['carrier'] if number['carrier']
      end
    end
    return result
  end
end
end
