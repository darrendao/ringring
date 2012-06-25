class CallListCalendarsController < ApplicationController
  def ical
    call_list_calendar = CallListCalendar.find(params[:id])
    @call_list = call_list_calendar.call_list
    oncall_assignments = @call_list.oncall_assignments
  
    cal = RiCal.Calendar do
      oncall_assignments.each do |oncall_assignment|
        event do
          description "oncall for #{oncall_assignment.call_list.name}"
          summary "#{oncall_assignment.call_list.name} - #{oncall_assignment.user.username}"
          dtstart     oncall_assignment.starts_at.to_date
          dtend       oncall_assignment.ends_at.to_date
          uid "#{call_list_calendar.id }-#{oncall_assignment.id}"
        end
      end
    end
    render :text => cal
  end
end
