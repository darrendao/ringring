module Ringring::Calendar
class Type
  CONFLUENCE_ICAL = "Remote Confluence iCal"
  LOCAL = "Local Calendar"

  def self.select_options
    constants.collect{|const| const_get(const)}
  end
end
end
