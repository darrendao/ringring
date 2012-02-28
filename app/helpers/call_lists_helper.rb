module CallListsHelper
  def setup_call_list(call_list)
    limit = 2 - call_list.call_list_owners.size
    (0..limit).each do |i|
      call_list.call_list_owners.build
    end

    call_list.call_list_calendar ||= CallListCalendar.new
    call_list
  end

  def display_calendar_link
    if @call_list.call_list_calendar && !@call_list.call_list_calendar.url.blank? 
      link_to(@call_list.call_list_calendar.url) + " (#{@call_list.call_list_calendar.ctype})"
    else
      "N/A"
    end
  end
end
