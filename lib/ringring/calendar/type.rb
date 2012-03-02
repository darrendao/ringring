module Ringring::Calendar
class Type
  CONFLUENCE_ICAL = "Confluence iCal"

  def self.select_options
    constants.collect{|const| const_get(const)}
  end
end
end
