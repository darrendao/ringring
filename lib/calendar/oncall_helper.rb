module Calendar
class OncallHelper
  SUCCESS = 0
  FETCH_CALENDAR_ERR = 1
  NO_ONCALL = 2
  UNKNOWN_ONCALL_USER = 3

  def self.update_oncalls(call_list)
    call_list_calendar = call_list.call_list_calendar
    new_oncalls = nil
    if call_list_calendar && !call_list_calendar.url.blank?
      new_oncalls = Calendar::ConfluenceIcal::find_oncall(call_list_calendar.url, DateTime.now)
    end
    
    if new_oncalls.nil? 
      return FETCH_CALENDAR_ERR
    end

    new_assignments = 0
    unknown_oncall_users = []
    oncall_assignments = call_list.oncall_assignments
    new_oncalls.each_with_index do |oncall, index|
      user = User.find_by_username(oncall)

      # Can't find user in our system
      return UNKNOWN_ONCALL_USER unless user

      oncall_assignment = oncall_assignments.pop
      if oncall_assignment
        oncall_assignment.user = user
        oncall_assignment.save
      else
        OncallAssignment.create(:user_id => user.id, :call_list_id => @call_list.id)
      end

      new_assignments += 1
    end

    # Delete leftover old assignments unless we didn't create any new assignment
    oncall_assignments.each {|oa| oa.destroy} unless new_assignments < 1

    # Check that there is at least one oncall_assignment
    call_list.reload
    if call_list.oncall_assignments.empty?
      return NO_ONCALL
    else
      return SUCCESS
    end
  end

  def self.handle_errors(error, call_list, handlers)
    case error
    when NO_ONCALL
      ErrorNotifier.no_oncall(call_list).deliver if handlers['email']
    when UNKNOWN_ONCALL_USER
      ErrorNotifier.unknown_oncall_users(call_list).deliver if handlers['email']
    when FETCH_CALENDAR_ERR
      ErrorNotifier.fetch_calendar_err(call_list).deliver if handlers['email']
    end
  end
end
end
