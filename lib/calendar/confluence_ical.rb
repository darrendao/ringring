require 'open-uri'
module Calendar
class ConfluenceIcal
  def self.find_oncall(url, datetime)
    data = nil
    begin
      data = open(url).read
    rescue => e
      return nil
    end

    oncall = []
    components = RiCal.parse_string data.gsub(/^M/, '').strip
    components.first.events.each do |e|
      e.occurrences.each do |occurrence|
        oncall << e.summary.split(/[\s,]+/) if occurrence.dtstart <= datetime && occurrence.dtend >= datetime
      end 
    end
    oncall.flatten 
  end
end
end
